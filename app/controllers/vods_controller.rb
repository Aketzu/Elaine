class VodsController < ApplicationController
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
		sort = case params[:sort]
			when 'program' then 'vods.program_id'
			when 'filename' then 'vods.filename'
			when 'length' then 'vods.length'
			when 'filesize' then 'vods.filesize'
			when 'completed' then 'vods.completed'
			when 'videoformat' then 'vods.video_format_id'
			when 'filelocation' then 'vods.file_location_id'
			when 'updated' then 'vods.updated_at'
			else 'completed'
		end
		order = case params[:order]
			when 'asc' then 'asc'
			when 'desc' then 'desc'
			else ''
		end

		sort += " " + order
			
		sort += ', program_id' 
    @vod_pages, @vods = paginate(:vods, :per_page => 100, :order => sort, :include => [:Program, :VideoFormat, :FileLocation])
  end

  def show
    @vod = Vod.find(params[:id])
  end

  def new
    @vod = Vod.new
  end

  def create
    @vod = Vod.new(params[:vod])
    if @vod.save
      flash[:notice] = 'Vod was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @vod = Vod.find(params[:id])
  end

  def update
    @vod = Vod.find(params[:id])
    if @vod.update_attributes(params[:vod])
      flash[:notice] = 'Vod was successfully updated.'
      redirect_to :action => 'show', :id => @vod
    else
      render :action => 'edit'
    end
  end

  def destroy
    Vod.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
