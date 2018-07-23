module GTFS
  module Model
    class GTFSAttribute
      attr_accessor :name, :csv_name, :optionnal

      def initialize(name,csv_name)
        @name = name
        @csv_name = csv_name
        @optionnal = false
      end

      def set_optionnal
        @optionnal = true
      end
    end
  end
end