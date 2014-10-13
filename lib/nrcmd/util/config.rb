module Nrcmd
  class Config
    class << self
      def load(conf_path)
        conf = { :nr_api_key => nil }
        # TODO: handle error, 'file does not exist'
        _conf = eval File.read "#{conf_path}"
        conf.merge! _conf
      end
    end
  end
end
