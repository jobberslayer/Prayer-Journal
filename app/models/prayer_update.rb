require 'lib/myconfig'
class PrayerUpdate < ActiveRecord::Base
  belongs_to :prayer_requests
  
  def belongs_to_user?(user_id)
    super_user_id = get_super_user_id()
    pr = PrayerRequest.find(PrayerRequest.find(prayer_request_id))
    return (user_id == pr.user_id or user_id == super_user_id)
  end
  
  def find_latest_viewable(user_id, limit=5)
    prayer_updates = []
    pus = PrayerUpdate.find(:all, :order => ["updated_at DESC"])
    pus.each do |pu|
      pr = PrayerRequest.find(pu.prayer_request_id)

      if pr.can_be_viewed?(user_id)
        prayer_updates << pu
      end
      if prayer_updates.length == limit
        return prayer_updates
      end
    end
    
    return prayer_updates
  end
  
  def get_super_user_id
    myconfig = Myconfig.instance
    return myconfig.super_user_id
  end
end
