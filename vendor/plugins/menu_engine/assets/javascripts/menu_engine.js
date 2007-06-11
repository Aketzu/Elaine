/*
 * MenuItem class
 */
var MenuItem = Class.create();
MenuItem.prototype = {
 initialize : function(menu_element)
 {
   this.menu_element = $(menu_element);
   this.menu = null;
   
   Event.observe(this.menu_element, "mouseout", this.mouse_out.bindAsEventListener(this));
   Event.observe(this.menu_element, "mouseover", this.mouse_over.bindAsEventListener(this));
 },
 
 add_sub_menu : function (sub_menu_element, position, on_show, on_hide)
 {
    // create a new submenu
    this.sub_menu = new SubMenu(sub_menu_element, this, position, on_show, on_hide);
    return this.sub_menu;
 },
 
 mouse_out : function ()
 {
    this.menu_element.className = this.menu_element.className.replace('highlighted', '');
 },
 
 mouse_over : function ()
 {
    this.menu_element.className += ' highlighted';
 }
 
}

/*
 * SubMenu class
 */
var SubMenu = Class.create();
SubMenu.prototype = {

 initialize : function(menu_element, parent, position, on_show, on_hide)
 {
    this.DELAY=20;
 
   this.menu_element = $(menu_element);
   this.parent = parent;
   this.position = position;
   this.hidden = false;
   this.items = new Array();
   this.positioned=false;
   this.on_show = on_show;
   this.on_hide = on_hide;
   
   // hide menu, make absolute and reattach to document.body
   this.menu_element.style.display='none';
   this.menu_element.style.position='absolute';
   
   // hook up events to parent
   Event.observe(parent.menu_element, "mouseover", this.parent_mouse_over.bindAsEventListener(this));
   Event.observe(parent.menu_element, "mouseout", this.mouse_out.bindAsEventListener(this));
   Event.observe(this.menu_element, "mouseout", this.mouse_out.bindAsEventListener(this));
   Event.observe(this.menu_element, "mouseover", this.mouse_over.bindAsEventListener(this));
 },
 
 add_item : function( item )
 {
    item.menu = this;
    this.items.push(item);
    return item;
 },
 
 parent_mouse_over : function()
 {
    this.keep_open();
    
    
    if (!this.positioned)
    {
        // attach submenu dto document.body for position calculations
        this.menu_element.parentNode.removeChild(this.menu_element);
        document.body.appendChild(this.menu_element);
        
        // reposition sub menu to parent
        if (this.position=='right')
        {
            this.menu_element.style.left = (Position.cumulativeOffset(this.parent.menu_element)[0] + Element.getDimensions(this.parent.menu_element).width) + "px";
            this.menu_element.style.top =  (Position.cumulativeOffset(this.parent.menu_element)[1]) + "px";
        } else
        {
            this.menu_element.style.left = Position.cumulativeOffset(this.parent.menu_element)[0] + "px";
            this.menu_element.style.top =  (Position.cumulativeOffset(this.parent.menu_element)[1] + Element.getHeight(this.parent.menu_element)) + "px";
        }
        this.menu_element.style.display='block';
        
        // adjust width = max(parent.width, max(item.width))
        var max_width = Element.getDimensions(this.parent.menu_element).width;
        this.items.each(function(item){
    				if (max_width < Element.getDimensions(item.menu_element).width)
    				    max_width = Element.getDimensions(item.menu_element).width
    			});
        this.items.each(function(item){
    				item.menu_element.style.width = max_width;
    			});
        this.menu_element.style.width=max_width + "px";
        this.menu_element.style.display='none';
        this.positioned=true;
    }
    this.show();
 },
 
 mouse_out : function ()
 {
    this.hide();
 },
 
 mouse_over : function ()
 {
    this.keep_open();
 },
 
 hide : function()
 {
    this.hidden = true;
    if (this.parent.menu)
        this.parent.menu.hide();
    setTimeout(this.hideCallback(this), this.DELAY);
 },
 
 show : function()
 {
    if (this.on_show)
    {
        element = this.menu_element;
        eval(this.on_show);
    } else
    {
        this.menu_element.style.display='block';
    }
 },
 
 keep_open : function()
 {
 	this.hidden = false;
 	if (this.parent.menu)
        this.parent.menu.keep_open();
 },
 
 
 hideCallback : function(to_hide)
 {
    return function()
    {
       if (to_hide.hidden)
       {
          if (to_hide.on_hide)
          {
            element = to_hide.menu_element;
            eval(to_hide.on_hide);
          } else
          {
            Element.hide(to_hide.menu_element);
          }
       }
    }
 }
 
 
}