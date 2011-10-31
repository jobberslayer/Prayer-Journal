# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def set_focus_to_id(id)
    javascript_tag("$('#{id}').focus()");
  end
  
  def set_focus_to_id_and_highlight(id)
    javascript_tag("$('#{id}').focus(); $('#{id}').select();")
  end
  
  def store_location
    session[:saved_location] = request.request_uri
  end
  
  def highlight_search_results(search, text)
		return (search.nil? || search.strip == '') ? text : text.gsub(/#{search}/i, '<font class="search-found">\0</font>')
  end
end
