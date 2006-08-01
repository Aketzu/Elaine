module MenuHelper

   def menu_item element_id, parent_id=nil
    if parent_id
      <<-MENUITEM
        var menu_item_#{element_id} = sub_menu_#{parent_id}.add_item( new MenuItem('#{element_id}') )
      MENUITEM
    else
      <<-MENUITEM
        var menu_item_#{element_id} = new MenuItem('#{element_id}');
      MENUITEM
    end
   end
   
   def sub_menu element_id, parent_id, options={}
      html = "var sub_menu_#{parent_id} = menu_item_#{parent_id}.add_sub_menu('#{element_id}', '#{options[:position]}'"
      html << ", '#{ MenuEngine.config(:on_show) }'"
      html << ", '#{ MenuEngine.config(:on_hide) }'"
      html << ");"
   end
   
   def build_menu options={}
    items = options[:menu]
    file ||= "config/menu"
    
    # the following line is important - YAML::load does not recognise the class otherwise
    # and returns a YAML::Object...
    MenuItem.new unless items 
    items ||= YAML::load(ERB.new(File.read("#{file}.yml")).result)
    
    # process access permissions for current user if user_engine is loaded
    # menu items that the user does not have access rights to are removed from the menu
    if defined?( UserEngine ) and MenuEngine.config(:access_control)
      user = session[:user]
      items = process_menu_authorization user, items if user
      items = [] unless user
    end
    items
   end
   
   def menu options={}
    @counter = 0
    items =  build_menu(options)
    html ="";
    
    # first, render the html code for the menu items
    for item in items
      html << render_item(item)
    end
    
    # second, render javascript block to initialise menu
    options[:level]=0
    html << "<script>"
    for item in items
      html << render_item_script(item, options)
    end
    html << "</script>"
   end
  
  private # internal methods do not need to be visible to helpers
   
   def process_menu_authorization user, items
      to_delete = []
      if items
        for item in items
           if not item.allow_all_access and not user.authorized?(item.controller, item.action)
            to_delete << item
           end
           item.items = process_menu_authorization user, item.items
        end
        items -= to_delete
      end
      items
   end
   
   
   def render_item item, level=0
      html = ""
      
      item.menu_id ||= (@counter += 1)
      text = item.text || item.controller.to_s.humanize.capitalize
      html << "<div style='width:auto' id='mn_#{item.menu_id}' class='menuitem level#{level}' onclick=\"document.location.href='#{ url_for :controller=>item.controller, :action=>item.action }';\" >#{ text }"

	  if (item.items and not item.items.empty?)
	   html << render_sub_menu(item, level)
	  end
	  html << "</div>\n"
   end
   
   def render_sub_menu item, level=0
    html = "<div id='sub_#{item.menu_id}' class='submenu'>"
    for child in item.items
      html << render_item(child, level+1)
    end
    html << "</div>"
   end
   
   def render_item_script item, options={}
      html = ""
      if options[:parent]
        html << menu_item("mn_#{item.menu_id}", "mn_#{options[:parent].menu_id}")
      else
        html << menu_item("mn_#{item.menu_id}")
      end
	  
	  if (item.items and not item.items.empty?)
	   html << render_sub_menu_script(item, options)
	  end
	  html
   end
   
   def render_sub_menu_script item, options
    if options[:level] == 0 and options[:layout]!=:vertical
      html = sub_menu("sub_#{item.menu_id}", "mn_#{item.menu_id}")
    else
      html = sub_menu("sub_#{item.menu_id}", "mn_#{item.menu_id}", :position=>'right')
    end
    for child in item.items
      html << render_item_script(child, :level=>options[:level]+1, :parent=>item )
    end
    html
   end   
   
end