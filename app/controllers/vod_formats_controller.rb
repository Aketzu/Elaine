class VodFormatsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @vod_format_pages, @vod_formats = paginate :vod_formats, :per_page => 10
  end

  def show
    @vod_format = VodFormat.find(params[:id])
  end

  def new
    @vod_format = VodFormat.new
  end

  def create
    @vod_format = VodFormat.new(params[:vod_format])
    if @vod_format.save
      flash[:notice] = 'VodFormat was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @vod_format = VodFormat.find(params[:id])
  end

  def update
    @vod_format = VodFormat.find(params[:id])
    if @vod_format.update_attributes(params[:vod_format])
      flash[:notice] = 'VodFormat was successfully updated.'
      redirect_to :action => 'show', :id => @vod_format
    else
      render :action => 'edit'
    end
  end

  def destroy
    VodFormat.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
