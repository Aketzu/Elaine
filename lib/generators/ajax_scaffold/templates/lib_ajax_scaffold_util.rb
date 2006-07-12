module AjaxScaffoldUtil

  def default_per_page
    25
  end

  def clear_flashes 
    #We want to clear flashes so they don't appear on a page reload
    if request.xhr? 
      flash.keys.each do |flash_key|
       flash[flash_key] = nil
      end
    end
  end
  
  def store_or_get_from_session(id_key, value_key)
    session[id_key][value_key] = params[value_key] if !params[value_key].nil?
    params[value_key] ||= session[id_key][value_key]
  end
  
  def update_params(options)
    @scaffold_id = params[:scaffold_id] ||= options[:default_scaffold_id]
    session[@scaffold_id] ||= {:sort => options[:default_sort], :sort_direction => options[:default_sort_direction], :page => 1}
    
    store_or_get_from_session(@scaffold_id, :sort)
    store_or_get_from_session(@scaffold_id, :sort_direction)
    store_or_get_from_session(@scaffold_id, :page)
  end
  
end