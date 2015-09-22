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
    DEFAULT_OPTIONS = {strict: true}

    attr_accessor :source, :archive, :options

    def initialize(source, opts={})
      raise 'Source cannot be nil' if source.nil?
      # Cache
      @cache = {}
      # Parents/children
      @parents = Hash.new { |h,k| h[k] = Set.new }
      @children = Hash.new { |h,k| h[k] = Set.new }
      # Temporary directory
      @tmp_dir = Dir.mktmpdir
      ObjectSpace.define_finalizer(self, self.class.finalize(@tmp_dir))
      # Filename
      @source = source
      load_archive(@source)
      # Load options
      @options = DEFAULT_OPTIONS.merge(opts)
    end

    def load_graph
      # Cache core entities
      default_agency = nil
      self.agencies.each { |e| default_agency = e }
      self.routes.each { |e| pclink(default_agency, e) }
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

    def each(filename, &block)
      cls = SOURCE_FILES[filename]
      cls.each(File.join(@tmp_dir, filename), options, &block)
    end

    def read(filename)
      cls = SOURCE_FILES[filename]
      if @cache[cls]
        return @cache[cls].values
      end
      @cache[cls] = {}
      self.each(filename) do |model|
        @cache[cls][model.id || model] = model
      end
      @cache[cls].values
    end

    ENTITIES.each do |entity|
      define_method entity.name.to_sym do
        self.read(entity.filename)
      end

      define_method "each_#{entity.singular_name}".to_sym do |&block|
        self.each(entity.filename) { |model| block.call model }
      end

      define_method "find_#{entity.singular_name}".to_sym do |key|
        @cache[entity][key]
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
