module GTFS
  class Transfer
    include GTFS::Model

    column_prefix :transfer_

    has_attributes :from_stop_id, :to_stop_id, :transfer_type, :min_transfer_time
    set_attributes_optional :min_transfer_time
    attr_accessor *attrs


    collection_name :transfers
    required_file false
    uses_filename 'transfers.txt'

    def self.parse_transfers(data, options={})
      return parse_models(data, options)
    end
  end
end
