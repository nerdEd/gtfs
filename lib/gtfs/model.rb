require 'gtfs/model/gtfs_attribute'
require 'gtfs/model/write_collection'
require 'gtfs/model/class_methods'

module GTFS
  module Model
    def self.included(base)
      base.extend ClassMethods

      base.class_variable_set('@@prefix', '')
      base.class_variable_set('@@attributes', [])

      def valid?
        !self.class.required_attrs.any?{|f| self.send(f.to_sym).nil?}
      end

      def initialize(attrs)
        attrs.each do |key, val|
          instance_variable_set("@#{key}", val)
        end
      end
    end

    def to_csv(columns)
      csv_values = []
      self.class.attrs.each do |attribute|
        csv_values << send(attribute) if columns.include?(attribute)
      end
      csv_values
    end
  end
end
