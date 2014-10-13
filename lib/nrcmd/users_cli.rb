require 'thor'

module Nrcmd
  class User < Thor
    namespace :user

    URL = 'https://api.newrelic.com/v2'


    desc "list", "show a list of all users"
    long_desc <<-LONGDESC
    Show a list of all users.

    https://rpm.newrelic.com/api/explore/users/list
    LONGDESC
    option :filter, :type => :string, :aliases => '-f', :default => ""
    def list
      uri = URL + '/users.json'
      filter_param = ""
      options["filter"].gsub(" ", "").split(',').each do |filter|
        fkv = filter.split('=')
        filter_param << "filter[#{fkv[0]}]=#{fkv[1]}&"
      end
      res = Nrcmd::Http.get(uri, {}, filter_param)
      result = JSON.parse(res.body)
      print JSON[ result ]
    end

    desc "show", "show a single user, identified by ID."
    long_desc <<-LONGDESC
    https://rpm.newrelic.com/api/explore/users/show
    LONGDESC
    def show(id)
      uri = URL + "/users/#{id}.json"
      res = Nrcmd::Http.get(uri)
      result = JSON.parse(res.body)
      print JSON[ result ]
    end
  end
end
