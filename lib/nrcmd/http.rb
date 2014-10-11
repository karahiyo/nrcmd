require 'active_support'

module Nrcmd
  class Http
    class << self
      def get(uri_str)
        uri = URI.parse(uri_str)
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        header = { "X-Api-Key" => Nrcmd.conf[:nr_api_key]}
        res = https.start {
          https.get(uri.request_uri, header)
        }
        if res.code == '200'
          return res
        else
          p "OMG!! #{res.code} #{res.message}"
        end
      end
    end
  end
end
