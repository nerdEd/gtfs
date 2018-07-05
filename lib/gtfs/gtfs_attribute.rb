module GTFS
  class GTFSAttribute
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
