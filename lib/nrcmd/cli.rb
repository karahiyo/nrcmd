require 'thor'
require 'net/http'
require 'uri'
require 'json'

module Nrcmd
  class CLI < Thor
    class_option :config, :type => :string
    class_option :verbose, :type => :boolean

    default_command :help

    def initialize(*args)
      super
      get_conf !!options["config"] ? options["config"] : "#{Dir.pwd}/config.rb"
    end

    desc "nrcmd help", ""
    def help
      p "no help ..."
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
    def get_conf(conf_path)
      @conf = eval File.read "#{conf_path}"
    end
  end
end
