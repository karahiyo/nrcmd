require 'thor'
require 'net/http'
require 'uri'
require 'json'

module Nrcmd
  class CLI < Thor
    default_command :help
    def initialize(*args)
      super
      get_conf
    end
    desc "nrcmd help", ""
    def help
      p "nrcmd <action> [service_name] [params] [option]"
    end
    desc "nrcmd list_appid", ""
    def list_appid
      uri = URI.parse('https://api.newrelic.com/v2/applications.json')
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      header = { "X-Api-Key" => @conf[:nr_api_key]}
      res = https.start {
        https.get(uri.request_uri, header)
      }
      if res.code == '200'
        result = JSON.parse(res.body)
        p result
      else
        p "OMG!! #{res.code} #{res.message}"
      end
    end

    private
    def get_conf
      @conf = eval File.read "#{Dir::pwd}/config.rb"
    end
  end
end
