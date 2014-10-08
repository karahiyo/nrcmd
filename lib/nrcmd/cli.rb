require 'thor'

module Nrcmd
  class CLI < Thor
    desc "nrcmd [option] <service_name> <action> [params]", ""
    def help
      p "nrcmd [option] <service_name> <action> [params]"
    end
  end
end
