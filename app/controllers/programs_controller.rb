class ProgramsController < ApplicationController
  sidebar :general

  before_filter :require_no_ssl if (RAILS_ENV == "production")

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }
  def list
    session[:original_uri] = request.request_uri
    @program_pages, @programs = paginate :programs, 
                                         :per_page => 10
  end

  def show
    session[:original_uri] = request.request_uri
    @program               = Program.find(params[:id])
    @program_events        = @program.program_event_links #Event.find(event).title
  end

  def new
    @program          = Program.new
    @program.do_vod = true
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

  def add_event
    @program = Program.find(params[:id])
    @program.ProgramEventLinks.create(params[:program_event])
    redirect_to session[:original_uri] || {:action => 'edit', :id => @program.id}
  end

  def move_event_up
    @program  = Program.find(params[:id])
    @program_event = @program.program_event_links.find(params[:program_event_id])
    @program_event.move_higher
    @program.reload
    redirect_to session[:original_uri] || {:action => 'edit', :id => @program.id}
  end

  def move_event_down
    @program  = Program.find(params[:id])
    @program_event = @program.program_event_links.find(params[:program_event_id])
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
    @program_event_link = ProgramEventLink.new(params[:program_event_link])
    begin
      @program_event_link.event_id = Event.find(:first, :conditions => ['title = ?', params[:event]["title"]]).id
    rescue
        redirect_to(:action => 'edit',
                    :id => @program_event_link.program_id)
    else
      if @program_event_link.save
        flash[:notice] = 'The event was successfully added.'
        redirect_to :action => 'edit',
                    :id => @program_event_link.program_id
      else
        render :action => 'new'
      end
    end
  end  
  
  def destroy
    Program.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  auto_complete_for :event, :title
end
