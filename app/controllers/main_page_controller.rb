class MainPageController < ApplicationController
  def index
    prayer_request_obj = PrayerRequest.new()
    @prayer_requests = prayer_request_obj.find_all_viewable(session[:user_id], 1, 5)
    
    prayer_update_obj = PrayerUpdate.new()
    @prayer_updates = prayer_update_obj.find_latest_viewable(session[:user_id], 5)
  end
end
