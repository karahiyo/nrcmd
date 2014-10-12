require 'active_support'

module Nrcmd
  class Http

    @header = { "X-Api-Key" => Nrcmd.conf[:nr_api_key] }

    class << self
      def get(uri_str, _header={})
        uri = URI.parse(uri_str)
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        header = @header.merge _header
        res = https.start {
          https.get(uri.request_uri, header)
        }
        if res.code == '200'
          return res
        else
          p "OMG!! #{res.code} #{res.message}"
          exit
        end
      end

      def put(uri_str, _header={}, param="")
        uri = URI.parse(uri_str)
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        https.set_debug_output $stderr if Nrcmd.log_level == "DEBUG"
        header = @header.merge _header
        req = Net::HTTP::Put.new(uri.request_uri, initheader = header)
        req.body = param
        res = https.start {
          https.request(req)
        }
        if res.code == '200'
          return res
        else
          p "OMG!! #{res.code} #{res.message}"
          exit
        end
      end
    end
  end
end
