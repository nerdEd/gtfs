module GTFS
  class Translation
    include GTFS::Model

    has_required_attrs :table_name, :field_name, :language, :translation
    has_optional_attrs :record_id, :record_sub_id, :field_value

    attr_accessor *attrs
    collection_name :translations

    required_file false
    uses_filename 'translations.txt'

    def self.parse_translations(data, options={})
      return parse_models(data, options)
    end
  end
end