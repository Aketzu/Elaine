class VodFilesController < ApplicationController
	require_permission ADMIN
  # GET /vod_files
  # GET /vod_files.xml
  def index
    @vod_files = VodFile.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @vod_files }
    end
  end

  # GET /vod_files/1
  # GET /vod_files/1.xml
  def show
    @vod_file = VodFile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vod_file }
    end
  end

  # GET /vod_files/new
  # GET /vod_files/new.xml
  def new
    @vod_file = VodFile.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @vod_file }
    end
  end

  # GET /vod_files/1/edit
  def edit
    @vod_file = VodFile.find(params[:id])
  end

  # POST /vod_files
  # POST /vod_files.xml
  def create
    @vod_file = VodFile.new(params[:vod_file])

    respond_to do |format|
      if @vod_file.save
        flash[:notice] = 'VodFile was successfully created.'
        format.html { redirect_to(@vod_file) }
        format.xml  { render :xml => @vod_file, :status => :created, :location => @vod_file }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @vod_file.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /vod_files/1
  # PUT /vod_files/1.xml
  def update
    @vod_file = VodFile.find(params[:id])

    respond_to do |format|
      if @vod_file.update_attributes(params[:vod_file])
        flash[:notice] = 'VodFile was successfully updated.'
        format.html { redirect_to(@vod_file) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vod_file.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /vod_files/1
  # DELETE /vod_files/1.xml
  def destroy
    @vod_file = VodFile.find(params[:id])
    @vod_file.destroy

    respond_to do |format|
      format.html { redirect_to(vod_files_url) }
      format.xml  { head :ok }
    end
  end
end
