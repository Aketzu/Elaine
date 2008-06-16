class ProgramDescriptionsController < ApplicationController
  # GET /program_descriptions
  # GET /program_descriptions.xml
  def index
    @program_descriptions = ProgramDescription.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @program_descriptions }
    end
  end

  # GET /program_descriptions/1
  # GET /program_descriptions/1.xml
  def show
    @program_description = ProgramDescription.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @program_description }
    end
  end

  # GET /program_descriptions/new
  # GET /program_descriptions/new.xml
  def new
    @program_description = ProgramDescription.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @program_description }
    end
  end

  # GET /program_descriptions/1/edit
  def edit
    @program_description = ProgramDescription.find(params[:id])
  end

  # POST /program_descriptions
  # POST /program_descriptions.xml
  def create
    @program_description = ProgramDescription.new(params[:program_description])

    respond_to do |format|
      if @program_description.save
        flash[:notice] = 'ProgramDescription was successfully created.'
        format.html { redirect_to(@program_description) }
        format.xml  { render :xml => @program_description, :status => :created, :location => @program_description }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @program_description.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /program_descriptions/1
  # PUT /program_descriptions/1.xml
  def update
    @program_description = ProgramDescription.find(params[:id])

    respond_to do |format|
      if @program_description.update_attributes(params[:program_description])
        flash[:notice] = 'ProgramDescription was successfully updated.'
        format.html { redirect_to(@program_description) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @program_description.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /program_descriptions/1
  # DELETE /program_descriptions/1.xml
  def destroy
    @program_description = ProgramDescription.find(params[:id])
    @program_description.destroy

    respond_to do |format|
      format.html { redirect_to(program_descriptions_url) }
      format.xml  { head :ok }
    end
  end
end
