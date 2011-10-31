class LoginController < ApplicationController
  def index()
    @login = Login.new()
  end
  
  def authenticate()
    login_info = params[:login]
    if (canceled?(login_info))
      return
    end
    
    @username = login_info['username']
    @password = login_info['password']
    
    @login = Login.new()
    begin
      user_info = @login.validate_login(@username, @password)
    rescue
      standard_error($!)
      return
    end
    
    if (user_info)
      session[:user_id] = user_info[:id]
      session[:user_name] = user_info[:name]
      redirect_to_back_or_default()
    else
      display_error('Could not log in using given username/password.')
    end
  end
  
  def logout()
    login_info = params[:login]
    if (canceled?(login_info))
      return
    end
    
    session[:user_id] = nil
    redirect_to_back_or_default()
  end
end
