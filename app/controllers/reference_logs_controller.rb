class ReferenceLogsController < ApplicationController
	require_permission DIRECTOR

  # GET /reference_logs
  # GET /reference_logs.xml
  def index
    @reference_logs = ReferenceLog.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reference_logs }
    end
  end

  # GET /reference_logs/1
  # GET /reference_logs/1.xml
  def show
    @reference_log = ReferenceLog.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @reference_log }
    end
  end

  # GET /reference_logs/new
  # GET /reference_logs/new.xml
  def new
    @reference_log = ReferenceLog.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @reference_log }
    end
  end

  # GET /reference_logs/1/edit
  def edit
    @reference_log = ReferenceLog.find(params[:id])
  end

  # POST /reference_logs
  # POST /reference_logs.xml
  def create
    @reference_log = ReferenceLog.new(params[:reference_log])

    respond_to do |format|
      if @reference_log.save
        flash[:notice] = 'ReferenceLog was successfully created.'
        format.html { redirect_to(@reference_log) }
        format.xml  { render :xml => @reference_log, :status => :created, :location => @reference_log }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @reference_log.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /reference_logs/1
  # PUT /reference_logs/1.xml
  def update
    @reference_log = ReferenceLog.find(params[:id])

    respond_to do |format|
      if @reference_log.update_attributes(params[:reference_log])
        flash[:notice] = 'ReferenceLog was successfully updated.'
        format.html { redirect_to(@reference_log) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @reference_log.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /reference_logs/1
  # DELETE /reference_logs/1.xml
  def destroy
    @reference_log = ReferenceLog.find(params[:id])
    @reference_log.destroy

    respond_to do |format|
      format.html { redirect_to(reference_logs_url) }
      format.xml  { head :ok }
    end
  end
end
