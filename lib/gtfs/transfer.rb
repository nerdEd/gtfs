module GTFS
  class Transfer
    include GTFS::Model

    has_required_attrs :from_stop_id, :to_stop_id, :transfer_type
    has_optional_attrs :min_transfer_time
    attr_accessor *attrs

    collection_name :transfers
    required_file false
    uses_filename 'transfers.txt'
  end
end
