class VideoFormatsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @video_format_pages, @video_formats = paginate :video_formats, :per_page => 10
  end

  def show
    @video_format = VideoFormat.find(params[:id])
  end

  def new
    @video_format = VideoFormat.new
  end

  def create
    @video_format = VideoFormat.new(params[:video_format])
    if @video_format.save
      flash[:notice] = 'VideoFormat was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @video_format = VideoFormat.find(params[:id])
  end

  def update
    @video_format = VideoFormat.find(params[:id])
    if @video_format.update_attributes(params[:video_format])
      flash[:notice] = 'VideoFormat was successfully updated.'
      redirect_to :action => 'list', :id => @video_format
    else
      render :action => 'edit'
    end
  end

  def destroy
    VideoFormat.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
