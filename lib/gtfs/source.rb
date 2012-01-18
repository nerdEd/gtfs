require 'tmpdir'
require 'zip/zip'

module GTFS
  class Source

    REQUIRED_SOURCE_FILES = %w{agency.txt stops.txt routes.txt trips.txt stop_times.txt calendar.txt}
    OPTIONAL_SOURCE_FILES = %w{calendar_dates.txt fare_attributes.txt fare_rules.txt shapes.txt frequencies.txt transfers.txt}
    SOURCE_FILES = REQUIRED_SOURCE_FILES + OPTIONAL_SOURCE_FILES

    attr_accessor :source, :archive

    def initialize(source)
      load_archive(source)
      @source = source
      if !has_required_sources?
        raise InvalidSourceException.new('Missing required source files')
      end
    end

    def load_archive(source)
      raise 'Cannot directly instantiate base GTFS::Source'
    end

    def self.build(data_root)
      if data_root.match(/http|www/) 
        URLSource.new(data_root) 
      else
        LocalSource.new(data_root)
      end
    end

    def has_required_sources?
      return false if @archive.nil?

      entries = @archive.entries.map(&:to_s)
      REQUIRED_SOURCE_FILES.each do |rf|
        return false if !entries.include?(rf)
      end
      true
    end
  end
end
