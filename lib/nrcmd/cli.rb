require 'thor'
require 'active_support/core_ext/module'

module Nrcmd

  autoload :Apps,       'nrcmd/apps/cli'
  autoload :Server,     'nrcmd/server/cli'
  autoload :User,       'nrcmd/users_cli'
  autoload :Config,     'nrcmd/util/config'
  autoload :Http,       'nrcmd/util/http'
  autoload :JSON,       'json'
  autoload :PP,         'pp'

  mattr_accessor :conf
  mattr_accessor :log_level

  class CLI < Thor

    URL = 'https://api.newrelic.com/v2'

    class_option :config, :type => :string, :aliases => "-c"
    class_option :verbose, :type => :boolean, :aliases => "-v"

    register(Apps, 'apps', 'apps <sub-command>', 'commands for Applications services')
    register(Server, 'server', 'server <sub-command>', 'commands for Servers services')
    register(User, 'user', 'user <sub-command>', 'commands for Users services')

    default_command :help
    def initialize(*args)
      super
      Nrcmd.conf = Nrcmd::Config.load(!!options["config"] ? options["config"] : "#{Dir.home}/.nrcmd_config.rb")
      Nrcmd.log_level = (!!options["verbose"] ? "DEBUG" : "INFO")
    end

    desc "configure", "setup your config file."
    def configure
      your_api_key = ask("Your NewRelic Api Key: ", :echo => false)
      conf = eval File.read "#{Dir.pwd}/nrcmd_config.rb"
      conf.merge! Hash[ :nr_api_key => your_api_key ]
      File.write("#{Dir.home}/.nrcmd_config.rb", PP.pp(conf, ''))
    end

  end
end

if __FILE__ == $0
  Nrcmd.start
end
