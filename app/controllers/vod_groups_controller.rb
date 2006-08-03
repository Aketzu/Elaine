class VodGroupsController < ApplicationController
  sidebar :general

  before_filter :require_no_ssl if (RAILS_ENV == "production")

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
      redirect_to :action => 'show', :id => @vod_group
    else
      render :action => 'edit'
    end
  end

  def destroy
    VodGroup.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
