require 'net/http'
require 'uri'

module GTFS
  class URLSource < Source

    MAXIMUM_REDIRECTS = 5

    def load_archive(source_url)
      original_source_url = source_url.dup
      Dir.mktmpdir do |tmp|
        n = 0
        while n < MAXIMUM_REDIRECTS
          uri = URI.parse(source_url)
          response = Net::HTTP.get_response(uri)
          if response.is_a?(Net::HTTPRedirection)
            n += 1
            source_url = response['location']
          else
            break
          end
        end
        if n >= MAXIMUM_REDIRECTS
          raise InvalidSourceException.new("Too many redirects for #{original_source_url}")
        end
        file_name = File.join(tmp, "/gtfs_temp_#{Time.now.strftime('%Y%jT%H%M%S%z')}.zip")
        open(file_name, 'wb') do |file|
          file.write response.body
        end
        extract_to_cache(file_name)
      end
    rescue Exception => e
      raise InvalidSourceException.new(e.message)
    end

  end
end
