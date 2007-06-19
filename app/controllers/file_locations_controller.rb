class FileLocationsController < ApplicationController
  sidebar :general

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @file_location_pages, @file_locations = paginate :file_locations, :per_page => 10
  end

  def show
    @file_location = FileLocation.find(params[:id])
    @programs = @file_location.Programs
    @events = @file_location.Events   
  end

  def new
    @file_location = FileLocation.new
  end

  def create
    @file_location = FileLocation.new(params[:file_location])
    if @file_location.save
      flash[:notice] = 'FileLocation was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @file_location = FileLocation.find(params[:id])
  end

  def update
    @file_location = FileLocation.find(params[:id])
    if @file_location.update_attributes(params[:file_location])
      flash[:notice] = 'FileLocation was successfully updated.'
      redirect_to :action => 'show', :id => @file_location
    else
      render :action => 'edit'
    end
  end

  def destroy
    FileLocation.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
