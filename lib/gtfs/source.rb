require 'tmpdir'
require 'fileutils'
require 'zip'

module GTFS
  class Source

    ENTITIES = [
      GTFS::Agency,
      GTFS::Stop,
      GTFS::Route,
      GTFS::Trip,
      GTFS::StopTime,
      GTFS::Calendar,
      GTFS::CalendarDate,
      GTFS::Shape,
      GTFS::FareAttribute,
      GTFS::FareRule,
      GTFS::Frequency,
      GTFS::Transfer,
      GTFS::FeedInfo
    ]
    REQUIRED_SOURCE_FILES = ENTITIES.select(&:required_file?).map(&:filename)
    OPTIONAL_SOURCE_FILES = ENTITIES.reject(&:required_file?).map(&:filename)
    SOURCE_FILES = Hash[ENTITIES.map { |e| [e.filename, e] }]
    DEFAULT_OPTIONS = {strict: false}

    attr_accessor :source, :archive, :options

    def initialize(source, opts={})
      raise 'Source cannot be nil' if source.nil?
      # Cache
      @cache = {}
      # Parents/children
      @parents = Hash.new { |h,k| h[k] = Set.new }
      @children = Hash.new { |h,k| h[k] = Set.new }
      # Trip counter
      @trip_counter = Hash.new { |h,k| h[k] = 0 }
      # Merged calendars
      # ...
      # Shape lines
      @shape_lines = {}
      # Temporary directory
      @tmp_dir = Dir.mktmpdir
      ObjectSpace.define_finalizer(self, self.class.finalize(@tmp_dir))
      # Load options
      @options = DEFAULT_OPTIONS.merge(opts)
      # Unzip to temporary directory
      @source = source
      load_archive(@source)
    end

    def pclink(parent, child)
      @parents[parent] << child
      @children[child] << parent
    end

    def parents(entity)
      @parents[entity]
    end

    def children(entity)
      @children[entity]
    end

    def cache(filename, &block)
      # Read entities, cache by ID.
      cls = SOURCE_FILES[filename]
      if @cache[cls]
        @cache[cls].values.each(&block)
      else
        @cache[cls] = {}
        cls.each(File.join(@tmp_dir, filename), options) do |model|
          @cache[cls][model.id || model] = model
          block.call model
        end
      end
    end

    # Define feed.<entities>, feed.each_<entity>, feed.find_<entity>
    ENTITIES.each do |cls|
      define_method cls.name.to_sym do
        ret = []
        self.cache(cls.filename) { |model| ret << model }
        ret
      end

      define_method "each_#{cls.singular_name}".to_sym do |&block|
        cls.each(File.join(@tmp_dir, cls.filename), options, &block)
      end

      define_method "find_#{cls.singular_name}".to_sym do |key|
        @cache[cls][key]
      end
    end

    private

    def self.finalize(directory)
      proc {FileUtils.rm_rf(directory)}
    end

    def self.build(data_root, opts={})
      if File.exists?(data_root)
        src = LocalSource.new(data_root, opts)
      else
        src = URLSource.new(data_root, opts)
      end
    end

    def extract_to_cache(source_path)
      Zip::File.open(source_path) do |zip|
        zip.entries.each do |entry|
          zip.extract(entry.name, File.join(@tmp_dir, '/', entry.name))
        end
      end
    end

    def load_archive(source)
      raise 'Cannot directly instantiate base GTFS::Source'
    end

    def entries
      Dir.entries(@tmp_dir)
    end

    def parse_file(filename)
      raise_if_missing_source filename
      open File.join(@tmp_dir, '/', filename), 'r:bom|utf-8' do |f|
        files[filename] ||= yield f
      end
    end

  end
end
