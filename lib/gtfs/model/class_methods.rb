require 'csv'

module GTFS
  module Model
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

      def set_attributes_optional(*attrs)
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
        CSV.parse(data, headers: true, liberal_parsing: true) do |row|
          model = parse_model(row.to_hash, options)
          models << model if options[:strict] == false || model.valid?
        end
        models
      end

      def new_write_collection
        WriteCollection.new(self)
      end

      def generate_csv(&block)
        CSV.generate do |csv|
          c = WriteCollection.new(self)
          yield c
          c.array_to_csv csv
        end
      end
    end
  end
end
