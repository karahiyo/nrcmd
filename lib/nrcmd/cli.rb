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

    class_option :config, :type => :string, :aliases => "-c"
    class_option :verbose, :type => :boolean, :aliases => "-v"

    default_command :help
    def initialize(*args)
      super
      Nrcmd.conf = Nrcmd::Config.load(!!options["config"] ? options["config"] : "#{Dir.pwd}/config.rb")
      Nrcmd.log_level = (!!options["verbose"] ? "DEBUG" : "INFO")
    end

    #
    #= Application
    #

    desc "list_apps", "list your applications"
    long_desc <<-LONGDESC
    with --filter, -f option, filtering applications by `name`, `ids`, `language`.

    https://rpm.newrelic.com/api/explore/applications/list
    LONGDESC
    option :filter, :type => :string, :aliases => '-f', :default => ""
    def list_apps()
      uri = URL + '/applications.json'
      filter_param = ""
      options["filter"].gsub(" ", "").split(',').each do |filter|
        fkv = filter.split('=')
        filter_param << "filter[#{fkv[0]}]=#{fkv[1]}&"
      end
      res = Nrcmd::Http.get(uri, {}, filter_param)
      result = JSON.parse(res.body)
      print JSON[ result["applications"] ]
    end

    desc "show_app <app_id>", "show summary data of a application."
    long_desc <<-LONGDESC
    https://rpm.newrelic.com/api/explore/applications/show
    LONGDESC
    def show_app(app_id)
      uri = URL + "/applications/#{app_id}.json"
      res = Nrcmd::Http.get(uri)
      result = JSON.parse(res.body)
      print JSON[ result["application"]]
    end

    desc "update_app <app_id> <json_param>", "update application setting."
    long_desc <<-LONGDESC
    `$ nrcmd update_app <app_id> '{"application": {"name": "rename_app_name"}}'

    sample json parameter

    ```
    {"application": {"name": "string"}}
    ```

    ```
    {
      "application": {
        "name": "string",
        "settings": {
          "app_apdex_threshold": "float",
          "end_user_apdex_threshold": "float",
          "enable_real_user_monitoring": "boolean"
        }
      }
    }
    ```

    https://rpm.newrelic.com/api/explore/applications/update
    LONGDESC
    def update_app(app_id, json_param)
      uri = URL + "/applications/#{app_id}.json"
      header = { 'Content-Type' => 'application/json' }
      data = json_param
      res = Nrcmd::Http.put(uri, header, data)
      result = JSON.parse(res.body)
      print JSON[ result ]
    end



    #
    #= Server
    #

    desc "list_servers", "list your servers."
    long_desc <<-LONGDESC
    with --filter, -f option, filtering applications by `name`, `ids`, `labels`.

    https://rpm.newrelic.com/api/explore/servers/list
    LONGDESC
    option :filter, :type => :string, :aliases => '-f', :default => ""
    def list_servers
      uri = URL + '/servers.json'
      filter_param = ""
      options["filter"].gsub(" ", "").split(',').each do |filter|
        fkv = filter.split('=')
        filter_param << "filter[#{fkv[0]}]=#{fkv[1]}&"
      end
      res = Nrcmd::Http.get(uri, {}, filter_param)
      result = JSON.parse(res.body)
      print JSON[ result["servers"] ]
    end

    desc "show_server <server_id>", "show summary data of a server."
    long_desc <<-LONGDESC
    https://rpm.newrelic.com/api/explore/servers/show
    LONGDESC
    def show_server(server_id)
      uri = URL + "/servers/#{server_id}.json"
      res = Nrcmd::Http.get(uri)
      result = JSON.parse(res.body)
      print JSON[ result["server"]]
    end

    desc "update_server <server_id> <json_param>", "update server setting."
    long_desc <<-LONGDESC
    sample json parameter

    ```
    {
      "server": {
        "name": "string"
      }
    }
    ```

    https://rpm.newrelic.com/api/explore/servers/update
    LONGDESC
    def update_server(server_id, json_param)
      uri = URL + "/servers/#{server_id}.json"
      header = { 'Content-Type' => 'application/json' }
      data = json_param
      res = Nrcmd::Http.put(uri, header, data)
      result = JSON.parse(res.body)
      print JSON[ result ]
    end


  end
end
