require 'CSV'

module GTFS
  class Stop 
    REQUIRED_ATTRS =  %w{id name lat lon}
    OPTIONAL_ATTRS = %w{code desc zone_id url location_type parent_station timezone}
    ATTRS = REQUIRED_ATTRS + OPTIONAL_ATTRS

    LOCATION_TYPE_STOP = 0
    LOCATION_TYPE_STATION = 1

    attr_accessor *ATTRS

    def initialize(attrs)
      attrs.each do |key, val|
        instance_variable_set("@#{key}", val)
      end
    end

    def valid?
      !REQUIRED_ATTRS.any?{|f| self.send(f.to_sym).nil?}
    end

    def self.strip_prefix(source)
      prefix = /stop_/
      return source.gsub(prefix, '') unless source.respond_to?(:each)
      source.map {|s| s.gsub(prefix, '')}  
    end

    def self.parse_stops(data)
      return [] if data.nil? || data.empty?

      stops = []
      CSV.parse(data, :headers => true) do |row|
        attr_hash = {}
        row.to_hash.each do |key, val|
          attr_hash[strip_prefix(key)] = val
        end
        stop = Stop.new(attr_hash)
        stops << stop if stop.valid?
      end
      stops
    end
  end
end

