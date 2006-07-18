class ProgramsController < ApplicationController
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
    @program         = Program.find(params[:id])
    @program_events  = @program.program_event_links #Event.find(event).title
  end

  def new
    @program          = Program.new
    @program.created  = Time.now
    @program.modified = Time.now
  end

  def create
    @program          = Program.new(params[:program])
    @program.created  = Time.now
    @program.modified = Time.now
    if @program.save
      for language in Language.get_compulsory
        description = ProgramDescription.new(:language_id => language.id, :program_id => @program.id)
        description.save
      end
      flash[:notice] = 'Program was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    session[:original_uri] = request.request_uri
    @program          = Program.find(params[:id])
    @program.modified = Time.now
  end

  def update
    @program          = Program.find(params[:id])
    @program.modified = DateTime.now
    if @program.update_attributes(params[:program])
      flash[:notice] = 'Program was successfully updated.'
      redirect_to :action => 'show', :id => @program
    else
      render :action => 'edit'
    end
  end

  def add_event
    @program = Program.find(params[:id])
    @program.ProgramEventLinks.create(params[:program_event])
    redirect_to session[:original_uri] || {:action => 'show', :id => @program.id}
  end

  def move_event_up
    @program  = Program.find(params[:id])
    @program_event = @program.program_event_links.find(params[:program_event_id])
    @program_event.move_higher
    @program.reload
    redirect_to session[:original_uri] || {:action => 'show', :id => @program.id}
  end

  def move_event_down
    @program  = Program.find(params[:id])
    @program_event = @program.program_event_links.find(params[:program_event_id])
    @program_event.move_lower
    @program.reload
    redirect_to session[:original_uri] || {:action => 'show', :id => @program.id}
  end

  def destroy
    Program.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
