require 'CSV'

module GTFS
  class Agency
    REQUIRED_ATTRS =  %w{name url timezone}
    OPTIONAL_ATTRS = %w{id lang phone fare_url}
    ATTRS = REQUIRED_ATTRS + OPTIONAL_ATTRS

    attr_accessor *ATTRS

    def initialize(attrs)
      attrs.each do |key, val|
        instance_variable_set("@#{key}", val)
      end
    end

    def valid?
      !REQUIRED_ATTRS.any?{|f| self.send(f.to_sym).nil?}
    end

    def self.parse_agencies(data)
      return [] if data.nil? || data.empty?

      agencies = []
      CSV.parse(data, :headers => true) do |row|
        attr_hash = {}
        row.to_hash.each do |key, val|
          attr_hash[key.gsub(/^agency_/, '')] = val
        end
        agency = Agency.new(attr_hash)
        agencies << agency if agency.valid?
      end
      agencies
    end
  end
end
