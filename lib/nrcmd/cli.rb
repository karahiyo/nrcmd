require 'thor'
require 'active_support/core_ext/module'

module Nrcmd

  autoload :Apps,       'nrcmd/apps_cli'
  autoload :Server,    'nrcmd/server_cli'
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

    register(Apps, 'apps', 'apps <sub-command>', 'sub-commands for Applications services')
    register(Server, 'server', 'server <sub-command>', 'sub-commands for Servers services')

  end
end
