class ProgramsController < ApplicationController
  auto_complete_for :event, :title

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

	def buildsearch
		@search = "true "
		@searchparams = Hash.new

		if params[:find_by_user] && params[:find_by_user] != "0"
			@user = User.find(params[:find_by_user])
			@search += " AND programs.owner_id = :owner_id "
			@searchparams[:owner_id] = @user.id
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
			@search += " AND program_descriptions.title ILIKE :title "
			@searchparams[:title] = "%#{@filter}%"
		end

		unless params[:ignore_date_filter] && params[:ignore_date_filter] != 'false'
			@search += " AND programs.created_at > :created_at "
			@searchparams[:created_at] = @date_filter = self.current_user.content_filter_date
		end

	end

  def list
    session[:original_uri] = request.request_uri
		@user ||= 0

		buildsearch
		
		sort = case params[:sort]
			when 'title' then 'program_descriptions.title'
			#when 'length' then 'length'
			when 'target' then 'target_length'
			when 'created' then 'programs.created_at'
			when 'modified' then 'programs.updated_at'
			when 'owner' then 'users.login'
			when 'status' then 'program_statuses.name'
			when 'vod' then 'do_vod'
			when 'minshow' then 'min_show'
			when 'maxshow' then 'max_show'
			when 'quarantine' then 'quarantine'
			else 'programs.created_at'
		end
		order = case params[:order]
			when 'asc' then 'asc'
			when 'desc' then 'desc'
			else ''
		end

		sort += " " + order
			
		sort += ', program_descriptions.language_id, program_event_links.position'

		@program_pages, @programs = paginate(:programs, 
																				 :per_page => 20,
																				 :order => sort,
#'programs.created_at, program_descriptions.language_id, program_event_links.position',
																				 :include => [:User, :ProgramStatus, :Events, :program_descriptions],
																				 :conditions => [@search, @searchparams])

		if request.xml_http_request?
			render :partial => "list", :layout => false
		end
  end
	
	def auto_complete_for_program_description_title
		buildsearch

		@items = ProgramDescription.find(:all, :order => 'title', :include => :Program, :conditions => [@search, @searchparams])
		render :inline => "<%= auto_complete_result @items, 'title' %>"
	end
	

  def show
    session[:original_uri] = request.request_uri
    @program               = Program.find(params[:id])
    @program_events        = @program.program_event_links #Event.find(event).title
  end

  def new
    @program          = Program.new
    @program.do_vod   = true
    @program_descriptions = []
    for language in Language.get_compulsory
      @program_descriptions << ProgramDescription.new(:language_id => language.id)
    end
  end

  def create
    Program.transaction do
      @program          = Program.new(params[:program])
      @program_descriptions = []    
      params[:program_description].each do |key, val|
        @program_descriptions << ProgramDescription.new(val)
      end
      unless @program.program_descriptions << @program_descriptions
        render :action => 'new'
      end
    end #end transaction

    if @program.save
      flash[:notice] = 'Program was successfully created.'
      redirect_to :action => 'edit', :id => @program.id
    else
      render :action => 'new'
    end
  end

  def edit
    session[:original_uri] = request.request_uri
    @program               = Program.find(params[:id])
    @program_events        = @program.program_event_links #Event.find(event).title
  end

  def update
    Program.transaction do
      @program          = Program.find(params[:id])
      params[:program_description].each do |key, val|
  	  description = ProgramDescription.find(key)
          unless description.update_attributes(val)
            flash[:error] = 'Problem with' + description.language.name + 'description'
            render :action => 'edit'
          end 
      end
    end # end transaction
    if @program.update_attributes(params[:program])
      flash[:notice] = 'Program was successfully updated.'
      redirect_to :action => 'edit', :id => @program
    else
      render :action => 'edit'
    end
  end

  #def add_event
  #  @program = Program.find(params[:id])
  #  @program.ProgramEventLinks.create(params[:program_event])
  #  redirect_to session[:original_uri] || {:action => 'edit', :id => @program.id}
  #end

  def move_event_up
    @program  = Program.find(params[:id])
    @program_event = @program.program_event_links.find(:first, :conditions => ["program_id = ? and event_id = ?", params[:id], params[:program_event_id]])
    @program_event.move_higher
    @program.reload
    redirect_to session[:original_uri] || {:action => 'edit', :id => @program.id}
  end

  def move_event_down
    @program  = Program.find(params[:id])
    @program_event = @program.program_event_links.find(:first, :conditions => ["program_id = ? and event_id = ?", params[:id], params[:program_event_id]])
    @program_event.move_lower
    @program.reload
    redirect_to session[:original_uri] || {:action => 'edit', :id => @program.id}
  end
  
  def set_status
    @program  = Program.find(params[:id])
    @status   = ProgramStatus.find(:first, :conditions => ['name = ?', params[:status]])
    unless(@status.nil?)
      @program.status_id = @status.id
      @program.save
    end
  end
  
  def add_event
		if params[:program_event_link][:event_id].to_i <= 0
			flash[:error] = 'Invalid event id specified';
    	@program = Program.find(params[:program_event_link][:program_id])
			render :partial => 'events', :layout => false, :object => @program.program_event_links
			return
		end

    @program_event_link = ProgramEventLink.new(params[:program_event_link])
		if @program_event_link.save
			flash[:notice] = 'The event was successfully added.'
		else
			flash[:error] = 'Error adding event:' + @program_event_link.errors.full_messages.join('<br />')
		end

    @program = Program.find(params[:program_event_link][:program_id])
		render :partial => 'events', :layout => false, :object => @program.Events
  end  
	def auto_complete_for_event_title
		@search = "true "
		@searchparams = Hash.new

		@filter ||= params[:event][:title] unless params[:event].nil?
		@filter ||= ""

		unless @filter.empty?
			@search += " AND title ILIKE :title "
			@searchparams[:title] = "%#{@filter}%"
		end
		unless params[:ignore_date_filter] && params[:ignore_date_filter] != 'false'
			@search += " AND created_at > :created_at "
			@searchparams[:created_at] = @date_filter = self.current_user.content_filter_date
		end
		if params[:event][:type].to_i > 0
			@search += " AND event_type_id = :type_id "
			@searchparams[:type_id] = params[:event][:type]
		end
		@items = Event.find(:all, :order => 'title', :conditions => [@search, @searchparams])

		render :inline => "<%= indexed_auto_complete_result @items, 'program_event_link_event_id', 'title', 'id' %>"
	end
  
  def destroy
    Program.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
end
