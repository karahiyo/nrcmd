require 'thor'
require 'active_support/core_ext/module'

module Nrcmd

  autoload :Config,     'nrcmd/config'
  autoload :Http,       'nrcmd/http'
  autoload :JSON,       'json'

  mattr_accessor :conf
  mattr_accessor :log_level

  class CLI < Thor

    URL = 'https://api.newrelic.com/v2'

    class_option :config, :type => :string, :aliases => "c"
    class_option :verbose, :type => :boolean, :aliases => "v"

    default_command :help
    def initialize(*args)
      super
      Nrcmd.conf = Nrcmd::Config.load(!!options["config"] ? options["config"] : "#{Dir.pwd}/config.rb")
      Nrcmd.log_level = (!!options["verbose"] ? "DEBUG" : "INFO")
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

    desc "nrcmd set_app_name <app_id> <app_name>", ""
    def set_app_name(app_id, app_name)
      uri = URL + "/applications/#{app_id}.json"
      header = { 'Content-Type' => 'application/json' }
      data = JSON[{ "application" => { "name" => app_name } }]
      res = Nrcmd::Http.put(uri, header, data)
      result = JSON.parse(res.body)
      print JSON[ result ]
    end
  end
end
