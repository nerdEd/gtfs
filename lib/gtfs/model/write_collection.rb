module GTFS
  module Model
    class WriteCollection
      def initialize(klass)
        @objects_array = []
        @klass = klass
        @unused_attrs = @klass.optional_attrs_objects.dup
      end

      def push(data)
        object = @klass.new(data)
        @unused_attrs.delete_if {|a| !object.send(a.name).nil? }
        @objects_array << object
      end
      alias_method :<<, :push

      def array_to_csv(csv)
        return if @objects_array.empty?
        csv << @klass.csv_attrs - @unused_attrs.map(&:csv_name)
        @objects_array.each {|o| csv << o.to_csv(@klass.attrs - @unused_attrs.map(&:name))}
      end
    end
  end
end
