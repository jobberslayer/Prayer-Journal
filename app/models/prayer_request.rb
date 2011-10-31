require 'lib/myconfig'

class PrayerRequest < ActiveRecord::Base
  has_many :prayer_updates
  
  validates_presence_of :title, :request
  
  def belongs_to_user?(user_id)
    super_user_id = get_super_user_id()
    return (self.user_id == user_id or user_id == super_user_id)
  end
  
  def can_be_viewed?(user_id)
    if user_id      
      if @super_user_id == user_id
        return true
      elsif self.private >= 1 or self.user_id == user_id
        return true
      else 
        return false
      end
    elsif self.private >=2
      return true
    else
      return false
    end
  end
  
  def find_all_viewable(user_id, page=1, limit=10, search=nil, answered=nil)
    conditions = []
    parameters = []
    conds, params = get_security_conditions(user_id)
    conditions.push(conds) if !conds.nil?
    parameters.push(params) if !params.nil?
    if !search.nil? && search.strip != ''
      search_pattern = search.sub(/\s{1,}/, '%')
      conditions.push('(request like ? or title like? or user_name like ? or pu.message like ?)')
      parameters.push("\%#{search_pattern}\%")
      parameters.push("\%#{search_pattern}\%")
      parameters.push("\%#{search_pattern}\%")
      parameters.push("\%#{search_pattern}\%")
    end

    if answered.nil?
    elsif answered
      conditions.push("(answered = 't')")
    else 
      conditions.push("(answered = 'f' or answered is null)")
    end
    
    conditions = build_conditions(conditions, parameters)
    
    #raise Array.pretty_print(conditions)

    join = nil 
    if (!search.nil? && search.strip != '') 
      join = 'LEFT JOIN prayer_updates pu on pu.prayer_request_id = prayer_requests.id'
    end
    
    PrayerRequest.paginate(:all, :conditions => conditions, 
        :joins => join,
        :order => ["prayer_requests.created_at DESC, title"], :per_page => limit, :page => page)      
  end

  def random(user_id)
    ids = find_all_viewable(user_id, nil, nil, nil, false)
    if ids.blank?
      return nil
    else
      return PrayerRequest.find(ids[rand(ids.length)]["id"].to_i) unless ids.blank?
    end
  end
  
  def find_id_viewable(user_id, id)
    conditions = []
    parameters = []
    conds, params = get_security_conditions(user_id)
    conditions.push(conds) if !conds.nil?
    parameters.concat(params) if !params.nil?
    
    conditions = build_conditions(conditions, parameters)
    #raise Array.pretty_print(conditions)
    
    if (conditions.length == 0)
      PrayerRequest.find(id)
    else
      PrayerRequest.find(id, :conditions => conditions)
    end
  end
  
  def get_security_conditions(user_id)
    super_user_id = get_super_user_id()
    if (user_id)
      if (super_user_id == user_id)
        return nil, nil
      else
        return "(private >= 1 or user_id = ?)", [user_id]
      end
    else
      return "private >= 2", nil
    end
  end
  
  def build_conditions(conditions, parameters)
    conditionStr = conditions.join(' and ')
    
    conditions = []
    conditions.push(conditionStr) if !conditionStr.empty?
    conditions.concat(parameters)
    
    return conditions
  end
  
  def get_super_user_id
    myconfig = Myconfig.instance
    return myconfig.super_user_id
  end
  
  def private_text
    return private_to_s(private)
  end
  
  def private_to_s(level)
    case level
      when 0 then 'private'
      when 1 then 'protected'
      when 2 then 'public'
    else
      'invalid'
    end
  end
end
