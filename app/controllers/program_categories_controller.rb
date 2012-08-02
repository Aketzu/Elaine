class ProgramCategoriesController < ApplicationController
	require_permission ADMIN

  # GET /program_categories
  # GET /program_categories.xml
  def index
    @program_categories = ProgramCategory.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @program_categories }
    end
  end

  # GET /program_categories/1
  # GET /program_categories/1.xml
  def show
    @program_category = ProgramCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @program_category }
    end
  end

  # GET /program_categories/new
  # GET /program_categories/new.xml
  def new
    @program_category = ProgramCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @program_category }
    end
  end

  # GET /program_categories/1/edit
  def edit
    @program_category = ProgramCategory.find(params[:id])
  end

  # POST /program_categories
  # POST /program_categories.xml
  def create
    @program_category = ProgramCategory.new(params[:program_category])

    respond_to do |format|
      if @program_category.save
        flash[:notice] = 'ProgramCategory was successfully created.'
        format.html { redirect_to(@program_category) }
        format.xml  { render :xml => @program_category, :status => :created, :location => @program_category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @program_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /program_categories/1
  # PUT /program_categories/1.xml
  def update
    @program_category = ProgramCategory.find(params[:id])

    respond_to do |format|
      if @program_category.update_attributes(params[:program_category])
        flash[:notice] = 'ProgramCategory was successfully updated.'
        format.html { redirect_to(@program_category) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @program_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /program_categories/1
  # DELETE /program_categories/1.xml
  def destroy
    @program_category = ProgramCategory.find(params[:id])
    @program_category.destroy

    respond_to do |format|
      format.html { redirect_to(program_categories_url) }
      format.xml  { head :ok }
    end
  end

  skip_before_filter :login_required, :only => [:caspar]
  skip_before_filter :check_auth, :only => [:caspar]
  
  def caspar
		@programs = ProgramCategory.find(params[:id]).programs

    render :layout => false, :template => 'channels/caspar'
  end
end
