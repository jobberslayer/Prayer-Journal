# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'lib/myconfig'

module StringMixin                                                                                                   
  def summarize(length=50)
    #Strip any html tags and then return only the value of #{length} first characters.
    self.gsub(/<\/?[^>]*>/, " ").gsub(/\s{2,}/, " ")[0, length].strip + "..."
  end
end

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery :secret => '7620ced0ead25371ecc634448ff8ee3a'
  
  attr_reader :myconfig
  attr_reader :super_user_id
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  def initialize
    @myconfig = Myconfig.instance
    @myconfig.load_config()
    super()
    String.send(:include, StringMixin)
  end

  def redirect_to_back_or_default()
    if session[:saved_location].nil?
      redirect_to @myconfig.default_redirect_url
    else
      redirect_to session[:saved_location]
      session[:saved_location] = nil
    end
  end
  
  def standard_error(msg)
    display_error(msg)
  end
  
  def canceled?(info)
    if info.include?('Cancel')
      redirect_to_back_or_default()
      return true
    end
  end
  
  def display_message(msg, style, back=false)
    flash[:notice] = msg
    flash[:style] = style
    if back
      redirect_to_back_or_default()
    else
      if request.referer.nil?
        redirect_to_back_or_default()
      else
        redirect_to request.referer
      end
    end
  end
  
  def display_error(msg, back=false)
    display_message(msg, 'flash_error', back)
  end
  
  def display_status(msg, back=false)
    display_message(msg, 'flash_status', back)
  end

end
