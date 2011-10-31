class PrayerRequestsController < ApplicationController
  # GET /prayer_requests
  # GET /prayer_requests.xml
  def index
    prayer_request_obj = PrayerRequest.new()
    @search = params[:search].nil? ? nil : params[:search][:search_text].strip
    @prayer_requests = prayer_request_obj.find_all_viewable(session[:user_id], params[:page], 5, @search, nil)

    if !@search.nil? && @search.empty?
      msg = "Searching for [#{@search}] is invalid.";
      display_error(msg)
      return
    end 

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @prayer_requests }
    end
  end
  
  def answered
    prayer_request_obj = PrayerRequest.new()
    @search = params[:search].nil? ? nil : params[:search][:search_text].strip
    @prayer_requests = prayer_request_obj.find_all_viewable(session[:user_id], params[:page], 5, @search, true)

    render :action => 'index'
    
    #respond_to do |format|
    #  format.html # index.html.erb
    #  format.xml  { render :xml => @prayer_requests }
    #end
  end

  def random
    prayer_request_obj = PrayerRequest.new()
    r = prayer_request_obj.random(session[:user_id])
    if r.nil?
      display_status('No unanswered prayers to randomly choose from.', true)
    else
      redirect_to :action => r.id.to_s
    end
  end

  # GET /prayer_requests/1
  # GET /prayer_requests/1.xml
  def show
    prayer_request_obj = PrayerRequest.new()
    begin
      @prayer_request = prayer_request_obj.find_id_viewable(session[:user_id], params[:id])
    rescue
      display_error("Problem retrieving prayer request. <br>" + $!, true)
      return
    end
    
    if @prayer_request.nil?
      display_error("Prayer request does not exist.", true)
      return
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @prayer_request }
    end
  end
  
  def show_updates
    @search = params[:search].nil? ? nil : params[:search][:search_text].strip
    prayer_request_obj = PrayerRequest.new()
    begin
      @prayer_request = prayer_request_obj.find_id_viewable(session[:user_id], params[:prayer_updates][:prayer_request_id])
    rescue
      display_error("Problem retrieving prayer request. <br>" + $!, true)
      return
    end
    
    if @prayer_request.nil?
      display_error("Prayer request does not exist.", true)
      return
    end
    
    @prayer_updates = @prayer_request.prayer_updates

    respond_to do |format|
      format.js # show_updates.js.rjs
    end
  end

  # GET /prayer_requests/new
  # GET /prayer_requests/new.xml
  def new
    @prayer_request = PrayerRequest.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @prayer_request }
    end
  end

  # GET /prayer_requests/1/edit
  def edit
    @prayer_request = PrayerRequest.find(params[:id])
    if (!@prayer_request.belongs_to_user?(session[:user_id]))
      display_error('You do not own this request and can not edit it.')
    end
  end

  # POST /prayer_requests
  # POST /prayer_requests.xml
  def create
    prayer_request_info = params[:prayer_request]
    if (canceled?(prayer_request_info))
      return
    end
    
    @prayer_request = PrayerRequest.new(prayer_request_info)
    @prayer_request.user_id = session[:user_id]
    @prayer_request.user_name = session[:user_name]

    if @prayer_request.save
      display_status('PrayerRequest was successfully created.', true)
    else
      render :action
    end
  end

  # PUT /prayer_requests/1
  # PUT /prayer_requests/1.xml
  def update
    prayer_request_info = params[:prayer_request]
    if (canceled?(prayer_request_info))
      return
    end
    
    @prayer_request = PrayerRequest.find(params[:id])

    if @prayer_request.update_attributes(params[:prayer_request])
      display_status('PrayerRequest was successfully updated.', true)
    else
      render :action => "edit"
    end
  end

  # DELETE /prayer_requests/1
  # DELETE /prayer_requests/1.xml
  def destroy
    @prayer_request = PrayerRequest.find(params[:id])
    if (!@prayer_request.belongs_to_user?(session[:user_id]))
      display_error('You do not own this request and can not delete it.')
      return
    end
    @prayer_request.prayer_updates.each do |pu|
      pu.destroy
    end
    @prayer_request.destroy

    respond_to do |format|
      format.html { redirect_to(prayer_requests_url) }
      format.xml  { head :ok }
    end
  end
end
