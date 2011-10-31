class PrayerUpdatesController < ApplicationController
  def new
    @prayer_request = PrayerRequest.find(params[:id])
    if (!@prayer_request.belongs_to_user?(session[:user_id]))
      display_error('You do not own this request and can not add an update.')
      return
    end
    @prayer_update = PrayerUpdate.new
    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  def index
    redirect_to prayer_requests_path
  end
  
  def show
    @prayer_update = PrayerUpdate.find(params[:id])
    #@prayer_request = PrayerRequest.find(@prayer_update.prayer_request_id)
    redirect_to prayer_requests_path + "/" + @prayer_update.prayer_request_id.to_s
  end
  
  def create
    prayer_update_info = params[:prayer_update]
    if canceled?(prayer_update_info)
      return
    end
  
    @prayer_update = PrayerUpdate.new(prayer_update_info)
    @prayer_request = PrayerRequest.find(@prayer_update.prayer_request_id)
    if (!@prayer_request.belongs_to_user?(session[:user_id]))
      display_error('You do not own this request to update it.')
      return
    end
    @prayer_update.prayer_request_id = @prayer_request.id
    @prayer_update.save
    redirect_to prayer_requests_path + "/" + @prayer_request.id.to_s
  end
  
  def destroy
    @prayer_update = PrayerUpdate.find(params[:id])
    @prayer_request = PrayerRequest.find(@prayer_update.prayer_request_id)
    if (!@prayer_request.belongs_to_user?(session[:user_id]))
      display_error('You do not own this update and can not delete it.')
      return
    end
    @prayer_update.destroy

    redirect_to(prayer_requests_url + "/" + @prayer_update.prayer_request_id.to_s)
  end
  
  def edit
    @prayer_update = PrayerUpdate.find(params[:id])
    @prayer_request = PrayerRequest.find(@prayer_update.prayer_request_id)
    if (!@prayer_request.belongs_to_user?(session[:user_id]))
      display_error('You do not own this update and can not edit it.')
    end
  end
  
  def update
    prayer_update_info = params[:prayer_update]
    if canceled?(prayer_update_info)
      return
    end
    @prayer_update = PrayerUpdate.find(params[:id])
    @prayer_request = PrayerRequest.find(@prayer_update.prayer_request_id)

    if @prayer_update.update_attributes(prayer_update_info)
      display_status('PrayerUpdate was sucessfully updated.', true)
    else
      render :action => "edit"
    end
  end
end
