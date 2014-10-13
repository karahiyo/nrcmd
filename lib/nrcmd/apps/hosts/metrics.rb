require 'thor'

module Nrcmd
  class Apps::Hosts::Metrics < Thor
    namespace 'apps hosts metrics'

    URL = 'https://api.newrelic.com/v2'

    desc "list <app_id> <host_id>", "show a list of known metrics and their value names for the given resource."
    long_desc <<-LONGDESC
    Return a list of known metrics and their value names for the given resource.

    https://rpm.newrelic.com/api/explore/application_hosts/names
    LONGDESC
    option :filter, :type => :string, :aliases => '-f', :default => ""
    def list(app_id, host_id)
      uri = URL + "/applications/#{app_id}/hosts/#{host_id}/metrics.json"
      filter_param = ""
      options["filter"].gsub(" ", "").split(',').each do |filter|
        fkv = filter.split('=')
        filter_param << "#{fkv[0]}=#{fkv[1]}&"
      end
      res = Nrcmd::Http.get(uri, {}, filter_param)
      result = JSON.parse(res.body)
      print JSON[ result ]
    end

    desc "get <app_id> <host_id>", "show a list of values for each of the requested metrics."
    long_desc <<-LONGDESC
    show a list of values for each of the requested metrics. The list of available metrics can be returned using the Metric Name API endpoint.
    Metric data can be filtered by a number of parameters, including multiple names and values, and by time range. Metric names and values will be matched intelligently in the background.

    You can also retrieve a sumarized data point across the entire time range selected by using the summarize parameter.

    https://rpm.newrelic.com/api/explore/application_hosts/data
    LONGDESC
    option :names, :type => :string, :aliases => '-n', :default => "", :required => true
    option :values, :type => :string
    option :summarize, :type => :boolean, :aliases => '-s'
    option :from, :type => :string, :default => nil
    option :to, :type => :string, :default => nil
    def get(app_id, host_id)
      uri = URL + "/applications/#{app_id}/hosts/#{host_id}/metrics/data.json"
      filter_param = ""
      filter_param << "names[]=#{options['names']}&"
      filter_param << "values[]=#{options['values']}&"
      filter_param << "from=#{options["from"]}&" if !!options["from"]
      filter_param << "to=#{options["to"]}&" if !!options["to"]
      res = Nrcmd::Http.get(uri, {}, filter_param)
      result = JSON.parse(res.body)
      print JSON[ result ]
    end
    def self.banner(task, namespace = false, subcommand = true)
      super
    end
  end
end


