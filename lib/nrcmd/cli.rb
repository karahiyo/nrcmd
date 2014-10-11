require 'thor'
require 'active_support'

module Nrcmd

  autoload :Config,     'nrcmd/config'
  autoload :Http,       'nrcmd/http'
  autoload :JSON,       'json'

  mattr_accessor :conf

  class CLI < Thor

    URL = 'https://api.newrelic.com/v2'

    class_option :config, :type => :string, :aliases => "-c"
    class_option :verbose, :type => :boolean, :aliases => "-v"

    default_command :help
    def initialize(*args)
      super
      Nrcmd.conf = Nrcmd::Config.load(!!options["config"] ? options["config"] : "#{Dir.pwd}/config.rb")
    end

    desc "nrcmd help", ""
    def help
      p "no help ..."
    end

    desc "nrcmd list_apps", ""
    def list_apps
      uri = URL + '/applications.json'
      res = Nrcmd::Http.get(uri)
      result = JSON.parse(res.body)
      print JSON[ result["applications"] ]
    end

    desc "nrcmd list_servers", ""
    def list_servers
      uri = URL + '/servers.json'
      res = Nrcmd::Http.get(uri)
      result = JSON.parse(res.body)
      print JSON[ result["servers"] ]
    end
  end
end
