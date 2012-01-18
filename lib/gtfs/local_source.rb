module GTFS
  class LocalSource < Source

    def load_archive(source_path)
      @archive = Zip::ZipFile.open(source_path)
    rescue Exception => e
      raise InvalidSourceException.new(e.message)
    end
  end
end
