# Represents a menu item as used by the MenuEngine
# 
class MenuItem
  include Reloadable

  attr_accessor :menu_id, :text, :controller, :action, :items, :allow_all_access
  
  def initialize attributes=nil
    @items= []
    return nil if attributes.nil?
    attributes.each do |key, value|    
      method("#{key}=").call(value)
    end
  end

end