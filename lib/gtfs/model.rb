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

      def required_file(required)
        self.define_singleton_method(:required_file?) {required}
      end

      def collection_name(collection_name)
        self.define_singleton_method(:name) {collection_name}

        self.define_singleton_method(:singular_name) {
          self.to_s.split('::').last.
            gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
            gsub(/([a-z\d])([A-Z])/,'\1_\2').
            tr("-", "_").downcase
        }
      end

      def uses_filename(filename)
        self.define_singleton_method(:filename) {filename}
      end

      def each(filename)
        CSV.foreach(filename, :headers => true) do |row|
          yield parse_model(row.to_hash)
        end
      end

      def parse_model(attr_hash, options={})
        unprefixed_attr_hash = {}

        attr_hash.each do |key, val|
          unprefixed_attr_hash[key.gsub(/^#{prefix}/, '')] = val
        end

        model = self.new(unprefixed_attr_hash)
      end

      def parse_models(data, options={})
        return [] if data.nil? || data.empty?

        models = []
        CSV.parse(data, :headers => true) do |row|
          model = parse_model(row.to_hash, options)
          models << model if options[:strict] == false || model.valid?
        end
        models
      end
    end
  end
end
