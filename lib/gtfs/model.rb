require 'csv'

module GTFS
  module Model
    def self.included(base)
      base.extend ClassMethods

      base.class_variable_set('@@prefix', '')
      base.class_variable_set('@@optional_attrs', [])
      base.class_variable_set('@@required_attrs', [])

      def valid?
        !self.class.required_attrs.any?{|f| self.send(f.to_sym).nil?}
      end

      def initialize(attrs)
        attrs.each do |key, val|
          instance_variable_set("@#{key}", val)
        end
      end
    end

    module ClassMethods

      #####################################
      # Getters for class variables
      #####################################

      def prefix
        self.class_variable_get('@@prefix')
      end

      def optional_attrs
        self.class_variable_get('@@optional_attrs')
      end

      def required_attrs
        self.class_variable_get('@@required_attrs')
      end

      def attrs
       required_attrs + optional_attrs
      end

      #####################################
      # Helper methods for setting up class variables
      #####################################

      def has_required_attrs(*attrs)
        self.class_variable_set('@@required_attrs', attrs)
      end

      def has_optional_attrs(*attrs)
        self.class_variable_set('@@optional_attrs', attrs)
      end

      def column_prefix(prefix)
        self.class_variable_set('@@prefix', prefix)
      end

      def parse_models(data)
        return [] if data.nil? || data.empty?

        models = []
        CSV.parse(data, :headers => true) do |row|
          attr_hash = {}
          row.to_hash.each do |key, val|
            attr_hash[key.gsub(/^#{prefix}/, '')] = val
          end
          model = self.new(attr_hash)
          models << model if model.valid?
        end
        models
      end
    end
  end
end
