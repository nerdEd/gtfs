require 'zip'

module GTFS
  class Target
    ENTITIES = [GTFS::Agency, GTFS::Stop, GTFS::Route, GTFS::Trip, GTFS::StopTime,
                GTFS::Calendar, GTFS::CalendarDate, GTFS::Shape, GTFS::FareAttribute,
                GTFS::FareRule, GTFS::Frequency, GTFS::Transfer, GTFS::FeedInfo]

    ENTITIES.each do |entity|
      self.define_singleton_method entity.name do
        csv = yield entity.send "generate_#{entity.name}"
        self.class_variable_set("@@#{entity.name}_csv", csv )
      end
    end

    def self.open (zip_file_path)
      yield self
      Zip::File.open(zip_file_path, Zip::File::CREATE) do |zipfile|
        ENTITIES.each do |entity|
          csv = self.class_variable_get(("@@#{entity.name}_csv"))
          zipfile.get_output_stream("#{entity.filename}") {|f| f.puts csv} unless csv.empty?
        end
      end
    end
  end
end
