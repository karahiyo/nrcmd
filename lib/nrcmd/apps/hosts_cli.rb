require 'thor'

module Nrcmd
  class Hosts < Thor

    URL = 'https://api.newrelic.com/v2'

    desc "list <app_id>", "list your hosts associated with the given app_id."
    long_desc <<-LONGDESC
    This API endpoint returns a paginated list of hosts associated with the given application.
    Application hosts can be filtered by hostname, or the list of application host IDs.

    with --filter, -f option, filtering applications by `hostname`, `ids`.

    https://rpm.newrelic.com/api/explore/application_hosts/list
    LONGDESC
    option :filter, :type => :string, :aliases => '-f', :default => ""
    def list(app_id)
      uri = URL + "/applications/#{app_id}/hosts.json"
      filter_param = ""
      options["filter"].gsub(" ", "").split(',').each do |filter|
        fkv = filter.split('=')
        filter_param << "filter[#{fkv[0]}]=#{fkv[1]}&"
      end
      res = Nrcmd::Http.get(uri, {}, filter_param)
      result = JSON.parse(res.body)
      print JSON[ result["application_hosts"] ]
    end

    desc "show <app_id> <host_id>", "show a single application host, identified by its ID."
    long_desc <<-LONGDESC
    https://rpm.newrelic.com/api/explore/application_hosts/show
    LONGDESC
    def show(app_id, host_id)
      uri = URL + "/applications/#{app_id}/hosts/#{host_id}.json"
      res = Nrcmd::Http.get(uri)
      result = JSON.parse(res.body)
      print JSON[ result["application_host"]]
    end
  end
end
