class VodGroupsController < ApplicationController
  sidebar :general

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @vod_group_pages, @vod_groups = paginate :vod_groups, :per_page => 10
  end

  def show
    @vod_group = VodGroup.find(params[:id])
  end

  def new
    @vod_group = VodGroup.new
  end

  def create
    @vod_group = VodGroup.new(params[:vod_group])
    if @vod_group.save
      flash[:notice] = 'VodGroup was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @vod_group = VodGroup.find(params[:id])
  end

  def update
    @vod_group = VodGroup.find(params[:id])
    if @vod_group.update_attributes(params[:vod_group])
      flash[:notice] = 'VodGroup was successfully updated.'
      redirect_to :action => 'list', :id => @vod_group
    else
      render :action => 'edit'
    end
  end

  def destroy
    VodGroup.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def add_vod_format
    @vod_group_format_link = VodGroupFormatLink.new(params[:vod_group_format_link])
    begin
      @vod_group_format_link.vod_format_id = VodFormat.find(:first, :conditions => ['name = ?', params[:vod_format]["name"]]).id
    rescue
        redirect_to(:action => 'show',
                    :id => @vod_group_format_link.vod_group_id)
    else
      if @vod_group_format_link.save
        flash[:notice] = 'The VOD format was successfully added.'
        redirect_to :action => 'show',
                    :id => @vod_group_format_link.vod_group_id
      else
        redirect_to :action => 'show',
                    :id => @vod_group_format_link.vod_group_id
      end
    end
  end  
  
  def remove_vod_format
    @vod_group_format_link = VodGroupFormatLink.find(params[:id])
    @redirect_id     = @vod_group_format_link.vod_group_id
    @vod_group_format_link.destroy
    flash[:notice] = 'The format was successfully removed'
    redirect_to :action => 'show',
                :id => @redirect_id  
  end
  
  auto_complete_for :vod_format, :name  
end
