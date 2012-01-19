module GTFS
  class LocalSource < Source

    def load_archive(source_path)
      extract_to_cache(source_path)
    rescue Exception => e
      raise InvalidSourceException.new(e.message)
    end
  end
end
