require 'thor'

module Nrcmd

  autoload :Config,     'nrcmd/config'
  autoload :JSON,       'json'

  class CLI < Thor
    class_option :config, :type => :string
    class_option :verbose, :type => :boolean

    default_command :help

    def initialize(*args)
      super
      @conf = Nrcmd::Config.load(!!options["config"] ? options["config"] : "#{Dir.pwd}/config.rb")
    end

    desc "nrcmd help", ""
    def help
      p "no help ..."
    end

    desc "nrcmd list_apps", ""
    def list_apps
      uri = URI.parse('https://' + 'api.newrelic.com' + '/v2' + '/applications.json')
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      header = { "X-Api-Key" => @conf[:nr_api_key]}
      res = https.start {
        https.get(uri.request_uri, header)
      }
      if res.code == '200'
        result = JSON.parse(res.body)
        print JSON[ result["applications"] ]
      else
        p "OMG!! #{res.code} #{res.message}"
      end
    end
  end
end
