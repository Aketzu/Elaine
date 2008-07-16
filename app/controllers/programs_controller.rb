class ProgramsController < ApplicationController

	def buildsearch
    @search = "1=1 "
    @searchparams = Hash.new

    if params[:find_by_user] && params[:find_by_user] != "0"
      @user = User.find(params[:find_by_user])
      @user = @user.id unless @user.nil?
      @search += " AND programs.owner_id = :owner_id "
      @searchparams[:owner_id] = @user
    end

    if params[:find_by_category] && params[:find_by_category] != "0"
      @category = ProgramCategory.find(params[:find_by_category])
      @category = @category.id unless @category.nil?
      @search += " AND programs.program_category_id = :category_id "
      @searchparams[:category_id] = @category
    end

    @filter ||= params[:search]
    @filter ||= params[:program_description][:title] unless params[:program_description].nil?
    @filter ||= ""

    unless @filter.empty?
      # TODO: ILIKE is Postgres specific, but is there another way?

      #Creates funny effects with multilanguage titles (i.e. same
      # programs appear with different titles depending on search
      # keywords == shows title in the language where keyword was found)
      #Fixing would require either dropping :include =>
      # :program_descriptions or additional SQL query in Program.title
      @search += " AND program_descriptions.title LIKE :title "
      @searchparams[:title] = "%#{@filter}%"
    end

		#FIXME
    #unless params[:ignore_date_filter] && params[:ignore_date_filter] != 'false'
    #  @search += " AND programs.created_at > :created_at "
    #  @searchparams[:created_at] = @date_filter = self.current_user.content_filter_date
    #end

  end


  # GET /programs
  # GET /programs.xml
  def index
		@user ||= 0
		@category ||= 0

		buildsearch
    sort = case params[:sort]
      when 'title'; 'program_descriptions.title'
      #when 'length'; 'length'
      when 'target'; 'target_length'
      when 'created'; 'programs.created_at'
      when 'modified'; 'programs.updated_at'
      when 'owner'; 'users.login'
      when 'status'; 'program_statuses.name'
      when 'vod'; 'do_vod'
      when 'minshow'; 'min_show'
      when 'maxshow'; 'max_show'
      when 'quarantine'; 'quarantine'
      else 'programs.created_at'
    end
    order = case params[:order]
      when 'asc'; 'asc'
      when 'desc'; 'desc'
      else ''
    end

    sort += " " + order
    sort += ', program_descriptions.lang'


    @programs = Program.roots.paginate \
			:page => params[:page], 
			:order => sort, 
			:include => [:program_descriptions, :program_category, :owner],
			:conditions => [@search, @searchparams]


    respond_to do |format|
      format.html {
					render :partial => "list" if request.xhr?
			}
      format.xml  { render :xml => @programs }
    end
  end

  # GET /programs/1
  # GET /programs/1.xml
  def show
    @program = Program.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @program }
    end
  end


	def import 
		#TODO: implement
    respond_to do |format|
      format.html # show.html.erb
    end
	end

  # GET /programs/new
  # GET /programs/new.xml
  def new
    @program = Program.new
		@program.owner = current_user
		@program.program_descriptions << ProgramDescription.Defaults

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @program }
    end
  end

  # GET /programs/1/edit
  def edit
    @program = Program.find(params[:id])
  end

  # POST /programs
  # POST /programs.xml
  def create
    @program = Program.new(params[:program])

		params[:program_description].each { |id, pdata|
			pd = ProgramDescription.new(pdata)
			@program.program_descriptions << pd
		}
		

    respond_to do |format|
      if @program.save
        flash[:notice] = 'Program was successfully created.'
        format.html { redirect_to(@program) }
        format.xml  { render :xml => @program, :status => :created, :location => @program }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @program.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /programs/1
  # PUT /programs/1.xml
  def update
    @program = Program.find(params[:id])

		params[:program_description].each { |id, pdata|
			pd = ProgramDescription.find(id)
			unless pd.update_attributes(pdata)
				flash[:notice] = 'Program description update failed.'
				render :action => "edit"
				return
			end
		}

    respond_to do |format|
      if @program.update_attributes(params[:program])
        flash[:notice] = 'Program was successfully updated.'
        format.html { redirect_to(program_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @program.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /programs/1
  # DELETE /programs/1.xml
  def destroy
    @program = Program.find(params[:id])
    @program.destroy

    respond_to do |format|
      format.html { redirect_to(programs_url) }
      format.xml  { head :ok }
    end
  end
end
