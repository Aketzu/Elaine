class <%= controller_class_name %>Controller < ApplicationController
  include AjaxScaffold::Controller
  
  after_filter :clear_flashes
  
<% unless suffix -%>
  def index
    redirect_to :action => 'list'
  end
<% end -%>

<% for action in unscaffolded_actions -%>
  def <%= action %><%= suffix %>
  end
<% end -%>

  def return_to_main
    # If you have multiple scaffolds on the same view then you will want to change this to
    # to whatever controller/action shows all the views 
    # (ex: redirect_to :controller => 'AdminConsole', :action => 'index')
    redirect_to :action => 'list'
  end

  def list
  end
  
  # All posts to change scaffold level variables like sort values or page changes go through this action
  def component_update  
    if request.xhr?
      # If this is an AJAX request then we just want to delegate to the component to rerender itself
      component
    else
      # If this is from a client without javascript we want to update the session parameters and then delegate
      # back to whatever page is displaying the scaffold, which will then rerender all scaffolds with these update parameters
      update_params :default_scaffold_id => "<%= singular_name %>", :default_sort => nil, :default_sort_direction => "asc"
      return_to_main
    end
  end

  def component
    update_params :default_scaffold_id => "<%= singular_name %>", :default_sort => nil, :default_sort_direction => "asc"
     
    @sort_sql = <%= model_name %>.scaffold_columns_hash[current_sort(params)].sort_sql rescue nil
    @sort_by = @sort_sql.nil? ? "#{<%= model_name %>.table_name}.#{<%= model_name %>.primary_key} asc" : @sort_sql  + " " + current_sort_direction(params)
    @paginator, @<%= plural_name %> = paginate(:<%= plural_name %>, :order => @sort_by, :per_page => default_per_page)
    
    render :action => "component", :layout => false
  end

  def new
    @<%= singular_name %> = <%= model_name %>.new
    @successful = true

    return render :action => 'new.rjs' if request.xhr?

    # Javascript disabled fallback
    if @successful
      @options = { :action => "create" }
      render :partial => "new_edit", :layout => true
    else 
      return_to_main
    end
  end
  
  def create
    begin
      @<%= singular_name %> = <%= model_name %>.new(params[:<%= singular_name %>])
      @successful = @<%= singular_name %>.save
    rescue
      flash[:error], @successful  = $!.to_s, false
    end
    
    return render :action => 'create.rjs' if request.xhr?
    if @successful
      return_to_main
    else
      @options = { :scaffold_id => params[:scaffold_id], :action => "create" }
      render :partial => 'new_edit', :layout => true
    end
  end

  def edit
    begin
      @<%= singular_name %> = <%= model_name %>.find(params[:id])
      @successful = !@<%= singular_name %>.nil?
    rescue
      flash[:error], @successful  = $!.to_s, false
    end
    
    return render :action => 'edit.rjs' if request.xhr?

    if @successful
      @options = { :scaffold_id => params[:scaffold_id], :action => "update", :id => params[:id] }
      render :partial => 'new_edit', :layout => true
    else
      return_to_main
    end    
  end

  def update
    begin
      @<%= singular_name %> = <%= model_name %>.find(params[:id])
      @successful = @<%= singular_name %>.update_attributes(params[:<%= singular_name %>])
    rescue
      flash[:error], @successful  = $!.to_s, false
    end
    
    return render :action => 'update.rjs' if request.xhr?

    if @successful
      return_to_main
    else
      @options = { :action => "update" }
      render :partial => 'new_edit', :layout => true
    end
  end

  def destroy
    begin
      @successful = <%= model_name %>.find(params[:id]).destroy
    rescue
      flash[:error], @successful  = $!.to_s, false
    end
    
    return render :action => 'destroy.rjs' if request.xhr?
    
    # Javascript disabled fallback
    return_to_main
  end
  
  def cancel
    @successful = true
    
    return render :action => 'cancel.rjs' if request.xhr?
    
    return_to_main
  end
end
