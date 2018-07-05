require 'csv'

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

    module ClassMethods

      #####################################
      # Getters for class variables
      #####################################

      def prefix
        self.class_variable_get('@@prefix')
      end

      def optional_attrs_objects
        self.class_variable_get('@@attributes').select{|a| a.optionnal}
      end

      def required_attrs
        self.class_variable_get('@@attributes').reject{|a| a.optionnal}.map(&:name)
      end

      def attrs
        self.class_variable_get('@@attributes').map(&:name)
      end

      def csv_attrs
        self.class_variable_get('@@attributes').map(&:csv_name)
      end


      #####################################
      # Helper methods for setting up class variables
      #####################################

      def has_attributes(*attrs)
        attrs.each {|a| self.class_variable_get('@@attributes') << GTFSAttribute.new(a.to_s.gsub(/^#{prefix}/, '').to_sym, a) }
      end

      def has_optional_attrs(*attrs)
        self.class_variable_get('@@attributes').map { |a| a.set_optionnal if attrs.include?(a.csv_name) }
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

    #####################################
    # Methods for CSV export
    #####################################

    class WriteCollection
      def initialize(csv, klass)
        @obects_array = []
        @csv = csv
        @klass = klass
        @unused_attrs = @klass.optional_attrs_objects.dup
      end

      def push(data)
        object = @klass.new(data)
        @unused_attrs.delete_if {|a| !object.send(a.name).nil? }
        @obects_array << object
      end
      alias_method :<<, :push

      def array_to_csv
        @csv << @klass.csv_attrs - @unused_attrs.map(&:csv_name)
        @obects_array.each {|o|  @csv << o.to_csv(@klass.attrs - @unused_attrs.map(&:name))}
      end
    end

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
