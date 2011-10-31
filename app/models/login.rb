require 'yaml'
require 'rubygems'
require 'hpricot'
require 'net/http'

class Login
  attr_accessor :username
  attr_accessor :password
  
  def initialize
    @APP_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/login.yml")[RAILS_ENV]
  end
  
  def validate_login(username, password)
    xml = getXML(username, password)
    #raise xml
    doc = Hpricot(xml)
    login = (doc/'return').inner_html
    if (login == 'true')
      user_info = {
        :id => (doc/'uid').inner_html.to_i,
        :name => (doc/'name').inner_html,
      }
      #raise user_info.to_s
      return user_info
    else
      return false
    end
  end
  
  def getXML(username, password) 
    username   = CGI::escape(username)
    password   = CGI::escape(password)
    db         = CGI::escape(@APP_CONFIG['db'])
    url        = @APP_CONFIG['url']
    controller = @APP_CONFIG['controller']
    
    asdf = Net::HTTP.start(url)
    command = "#{controller}?a=grace&b=#{username}&c=#{password}&d=asdf"
    req = Net::HTTP::Get.new(command)
    res = asdf.request(req)
    
    unless res.is_a? Net::HTTPOK
      raise "Problem verifying login. Please email Kevin Lester and let him know." 
    end
    
    return res.body
  end
  
  def check_password(db_entry, password)
    return false if db_entry.nil?
    parts = db_entry.split(/\:/)
    crypt_pass = parts[0]
    salt = parts[1]
    
    return Digest::MD5.hexdigest(password + salt) == crypt_pass
  end
end
