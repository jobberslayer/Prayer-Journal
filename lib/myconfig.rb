require 'yaml'
require 'singleton'

class Myconfig
  include Singleton
  
  attr_reader :super_user_id
  attr_reader :default_redirect_url
  attr_reader :mongrel_start_port
  attr_reader :mongrel_number_processes
  
  def load_config()
    myconfig = YAML.load_file("#{RAILS_ROOT}/config/myconfig.yml")[RAILS_ENV]
    @super_user_id = myconfig['super_user_id']
    @default_redirect_url = myconfig['default_redirect_url']
    @mongrel_start_port = myconfig['mongrel_start_port']
    @mongrel_number_processes = myconfig['mongrel_number_processes']
  end
end