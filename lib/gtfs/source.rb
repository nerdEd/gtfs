require 'tmpdir'
require 'fileutils'
require 'zip/zip'

module GTFS
  class Source

    ENTITIES = [GTFS::Agency, GTFS::Stop, GTFS::Route, GTFS::Trip, GTFS::StopTime,
                GTFS::Calendar, GTFS::CalendarDate, GTFS::Shape, GTFS::FareAttribute,
                GTFS::FareRule, GTFS::Frequency, GTFS::Transfer]

    REQUIRED_SOURCE_FILES = ENTITIES.select(&:required_file?).map(&:filename)
    OPTIONAL_SOURCE_FILES = ENTITIES.reject(&:required_file?).map(&:filename)
    SOURCE_FILES = ENTITIES.map(&:filename)

    attr_accessor :source, :archive

    def initialize(source)
      raise 'Source cannot be nil' if source.nil?

      @tmp_dir = Dir.mktmpdir
      ObjectSpace.define_finalizer(self, self.class.finalize(@tmp_dir))

      @source = source
      load_archive(@source)
    end

    def self.finalize(directory)
      proc {FileUtils.rm_rf(directory)}
    end

    def extract_to_cache(source_path)
      Zip::ZipFile.open(source_path) do |zip|
        zip.entries.each do |entry|
          zip.extract(entry.name, File.join(@tmp_dir, '/', entry.name))
        end
      end
    end

    def load_archive(source)
      raise 'Cannot directly instantiate base GTFS::Source'
    end

    def self.build(data_root)
      if File.exists?(data_root)
        LocalSource.new(data_root)
      else
        URLSource.new(data_root)
      end
    end

    def entries
      Dir.entries(@tmp_dir)
    end

    def raise_if_missing_source(filename)
      file_missing = !entries.include?(filename)
      raise InvalidSourceException.new("Missing required source file: #{filename}") if file_missing
    end

    ENTITIES.each do |entity|
      define_method entity.name.to_sym do
        parse_file entity.filename do |f|
          entity.send("parse_#{entity.name}".to_sym, f.read)
        end
      end
    end

    def files
      @files ||= {}
    end

    def parse_file(filename)
      raise_if_missing_source filename
      open File.join(@tmp_dir, '/', filename), 'r:bom|utf-8' do |f|
        files[filename] ||= yield f
      end
    end
  end
end
