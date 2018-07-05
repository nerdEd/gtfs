module GTFS
  module Model
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
  end
end