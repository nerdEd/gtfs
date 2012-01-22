require 'CSV'

module GTFS
  class Agency
    REQUIRED_FIELDS = %w{agency_name agency_url agency_timezone}
    OPTIONAL_FIELDS = %w{agency_id agency_lang agency_phone agency_fare_url}
    FIELDS = REQUIRED_FIELDS + OPTIONAL_FIELDS

    ATTRS = *FIELDS.map{|f| f.gsub(/^agency_/, '')}
    attr_accessor *ATTRS

    def initialize(attrs)
      attrs.each do |key, val|
        att = key.gsub(/^agency_/, '') + '='
        send(att.to_sym, val)
      end
    end

    def valid?
      REQUIRED_FIELDS.map{|f| f.gsub(/^agency_/, '')}.each do |f|
        return false if self.send(f.to_sym) == nil
      end
      true
    end

    def self.parse_agencies(data)
      return [] if data.nil? || data.empty?

      agencies = []
      CSV.parse(data, :headers => true) do |row|
        agency = Agency.new(row.to_hash)
        agencies << agency if agency.valid?
      end
      agencies
    end
  end
end
