require 'tmpdir'
require 'fileutils'
require 'stringio'
require 'zip'

module GTFS
  class Source

    ENTITIES = [GTFS::Agency, GTFS::Stop, GTFS::Route, GTFS::Trip, GTFS::StopTime,
                GTFS::Calendar, GTFS::CalendarDate, GTFS::Shape, GTFS::FareAttribute,
                GTFS::FareRule, GTFS::Frequency, GTFS::Transfer, GTFS::FeedInfo]

    REQUIRED_SOURCE_FILES = ENTITIES.select(&:required_file?).map(&:filename)
    OPTIONAL_SOURCE_FILES = ENTITIES.reject(&:required_file?).map(&:filename)
    SOURCE_FILES = ENTITIES.map(&:filename)

    DEFAULT_OPTIONS = {strict: true}

    attr_accessor :source, :archive, :options

    def initialize(source, opts={})
      raise 'Source cannot be nil' if source.nil?

      @tmp_dir = Dir.mktmpdir
      ObjectSpace.define_finalizer(self, self.class.finalize(@tmp_dir))

      @source = source
      load_archive(@source)

      @options = DEFAULT_OPTIONS.merge(opts)
    end

    def self.finalize(directory)
      proc {FileUtils.rm_rf(directory)}
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

    def self.build(data_root, opts={})
      if File.exists?(data_root)
        src = LocalSource.new(data_root, opts)
      else
        src = URLSource.new(data_root, opts)
      end
    end

    def entries
      Dir.entries(@tmp_dir)
    end

    def raise_if_required_source(entity)
      raise InvalidSourceException.new("Missing required source file: #{entity.filename}") if entity.required_file?
    end

    ENTITIES.each do |entity|
      define_method entity.name.to_sym do
        parse_entity entity do |f|
          files[entity.filename] ||= f
          entity.send("parse_#{entity.name}".to_sym, f.read, options)
        end
      end

      define_method "each_#{entity.singular_name}".to_sym do |&block|
        entity.each(File.join(@tmp_dir, entity.filename)) { |model| block.call model }
      end
    end

    def files
      @files ||= {}
    end

    def parse_entity(entity)
      if entries.include?(entity.filename)
        yield open(File.join(@tmp_dir, entity.filename), 'r:bom|utf-8')
      else
        raise_if_required_source entity
        yield StringIO.new
      end
    end
  end
end
