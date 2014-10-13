require 'thor'

module Nrcmd
  class Apps < Thor

    Nrcmd.autoload :Metrics,      'nrcmd/apps/metrics_cli'
    Nrcmd.autoload :Hosts,        'nrcmd/apps/hosts_cli'

    register(Metrics, 'metrics', 'metrics <sub-command>', 'sub-commands for Applications Metrics services')
    register(Hosts, 'hosts', 'hosts <sub-command>', 'sub-commands for Applications Hosts services')

    #desc 'hosts <sub-command>', 'sub-commands for Applications Hosts services'
    #subcommand "hosts", Hosts

    #desc 'metrics <sub-command>', 'sub-commands for Applications Metrics services'
    #subcommand "metrics", Metrics

    URL = 'https://api.newrelic.com/v2'

    desc "list", "list your applications"
    long_desc <<-LONGDESC
    with --filter, -f option, filtering applications by `name`, `ids`, `language`.

    https://rpm.newrelic.com/api/explore/applications/list
    LONGDESC
    option :filter, :type => :string, :aliases => '-f', :default => ""
    def list()
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

    desc "show <app_id>", "show summary data of a application."
    long_desc <<-LONGDESC
    https://rpm.newrelic.com/api/explore/applications/show
    LONGDESC
    def show(app_id)
      uri = URL + "/applications/#{app_id}.json"
      res = Nrcmd::Http.get(uri)
      result = JSON.parse(res.body)
      print JSON[ result["application"]]
    end

    desc "update <app_id> <json_param>", "update application setting."
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
    def update(app_id, json_param)
      uri = URL + "/applications/#{app_id}.json"
      header = { 'Content-Type' => 'application/json' }
      data = json_param
      res = Nrcmd::Http.put(uri, header, data)
      result = JSON.parse(res.body)
      print JSON[ result ]
    end

    desc "delete_app <app_id>", "deletes a application and all of reported data."
    long_desc <<-LONGDESC
    https://rpm.newrelic.com/api/explore/applications/delete
    LONGDESC
    def __delete(id)
      uri = URL + "/applications/#{id}.json"
      res = Nrcmd::Http.delete(uri)
      result = JSON.parse(res.body)
      print JSON[ result ]
    end
  end
end
