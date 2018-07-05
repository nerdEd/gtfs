require 'zip'

module GTFS
  class Target
    ENTITIES = [GTFS::Agency, GTFS::Stop, GTFS::Route, GTFS::Trip, GTFS::StopTime,
                GTFS::Calendar, GTFS::CalendarDate, GTFS::Shape, GTFS::FareAttribute,
                GTFS::FareRule, GTFS::Frequency, GTFS::Transfer, GTFS::FeedInfo]

    def initialize
      ENTITIES.each do |entity|
        instance_variable_set("@#{entity.name}_csv", entity.new_write_collection )

        define_singleton_method entity.name do |&block|
          instance_variable_get("@#{entity.name}_csv")
        end
      end
    end

    def self.open (zip_file_path)
      target = Target.new
      yield target
      Zip::File.open(zip_file_path, Zip::File::CREATE) do |zipfile|
        ENTITIES.each do |entity|
          entity_csv = CSV.generate do |csv|
            c = target.instance_variable_get(("@#{entity.name}_csv"))
            c.array_to_csv csv
          end

          zipfile.get_output_stream("#{entity.filename}") {|f| f.puts entity_csv} if entity.required_file? || (!entity_csv.nil? && !entity_csv.empty?)
        end
      end
    end
  end
end
