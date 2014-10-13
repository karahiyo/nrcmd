require 'thor'

module Nrcmd
  class Server < Thor
    namespace :server

    Nrcmd.autoload :Metrics,      'nrcmd/server/metrics'

    register(Metrics, 'metrics', 'metrics <sub-command>', 'sub-commands for Servers Metrics services')

    URL = 'https://api.newrelic.com/v2'

    desc "list", "list your servers."
    long_desc <<-LONGDESC
    with --filter, -f option, filtering servers by `name`, `ids`, `labels`.

    https://rpm.newrelic.com/api/explore/servers/list
    LONGDESC
    option :filter, :type => :string, :aliases => '-f', :default => ""
    def list
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

    desc "show <server_id>", "show summary data of a server."
    long_desc <<-LONGDESC
    https://rpm.newrelic.com/api/explore/servers/show
    LONGDESC
    def show(server_id)
      uri = URL + "/servers/#{server_id}.json"
      res = Nrcmd::Http.get(uri)
      result = JSON.parse(res.body)
      print JSON[ result["server"]]
    end

    desc "update <server_id> <json_param>", "update server setting."
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
    def update(server_id, json_param)
      uri = URL + "/servers/#{server_id}.json"
      header = { 'Content-Type' => 'application/json' }
      data = json_param
      res = Nrcmd::Http.put(uri, header, data)
      result = JSON.parse(res.body)
      print JSON[ result ]
    end

    desc "delete <server_id>", "deletes a server and all of reported data."
    long_desc <<-LONGDESC
    https://rpm.newrelic.com/api/explore/servers/delete
    LONGDESC
    def __delete(id)
      uri = URL + "/servers/#{id}.json"
      res = Nrcmd::Http.delete(uri)
      result = JSON.parse(res.body)
      print JSON[ result ]
    end
  end
end

