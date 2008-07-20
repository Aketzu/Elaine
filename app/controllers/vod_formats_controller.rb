class VodFormatsController < ApplicationController
	require_permission ADMIN
  # GET /vod_formats
  # GET /vod_formats.xml
  def index
    @vod_formats = VodFormat.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @vod_formats }
    end
  end

  # GET /vod_formats/1
  # GET /vod_formats/1.xml
  def show
    @vod_format = VodFormat.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vod_format }
    end
  end

  # GET /vod_formats/new
  # GET /vod_formats/new.xml
  def new
    @vod_format = VodFormat.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @vod_format }
    end
  end

  # GET /vod_formats/1/edit
  def edit
    @vod_format = VodFormat.find(params[:id])
  end

  # POST /vod_formats
  # POST /vod_formats.xml
  def create
    @vod_format = VodFormat.new(params[:vod_format])

    respond_to do |format|
      if @vod_format.save
        flash[:notice] = 'VodFormat was successfully created.'
        format.html { redirect_to(@vod_format) }
        format.xml  { render :xml => @vod_format, :status => :created, :location => @vod_format }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @vod_format.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /vod_formats/1
  # PUT /vod_formats/1.xml
  def update
    @vod_format = VodFormat.find(params[:id])

    respond_to do |format|
      if @vod_format.update_attributes(params[:vod_format])
        flash[:notice] = 'VodFormat was successfully updated.'
        format.html { redirect_to(@vod_format) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vod_format.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /vod_formats/1
  # DELETE /vod_formats/1.xml
  def destroy
    @vod_format = VodFormat.find(params[:id])
    @vod_format.destroy

    respond_to do |format|
      format.html { redirect_to(vod_formats_url) }
      format.xml  { head :ok }
    end
  end
end
