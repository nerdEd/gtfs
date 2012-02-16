module GTFS
  module Model
    def self.included(base)
      base.extend ClassMethods

      def valid?
        !self.class::REQUIRED_ATTRS.any?{|f| self.send(f.to_sym).nil?}
      end

      def initialize(attrs)
        attrs.each do |key, val|
          instance_variable_set("@#{key}", val)
        end
      end
    end

    module ClassMethods
      def required_attrs(*attrs)
        const_set('REQUIRED_ATTRS', attrs)
      end

      def optional_attrs(*attrs)
        const_set('OPTIONAL_ATTRS', attrs)
      end

      def column_prefix(prefix)
        const_set('PREFIX', prefix)
      end

      def attrs
        self::REQUIRED_ATTRS + self::OPTIONAL_ATTRS
      end

      def parse_models(data)
        return [] if data.nil? || data.empty?

        models = []
        CSV.parse(data, :headers => true) do |row|
          attr_hash = {}
          row.to_hash.each do |key, val|
            attr_hash[key.gsub(/^#{self::PREFIX}/, '')] = val
          end
          model = self.new(attr_hash)
          models << model if model.valid?
        end
        models
      end
    end
  end
end
