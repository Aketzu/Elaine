class TapesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @tape_pages, @tapes = paginate :tapes, 
                                   :per_page => 10
  end

  def show
    @tape  = Tape.find(params[:id])
    @programs = @tape.tape_program_links.find(:all, :order => 'start_time')
    @events = @tape.tape_event_links.find(:all, :order => 'start_time')
  end

  def new
    @tape = Tape.new
  end

  def create
    @tape = Tape.new(params[:tape])
    if @tape.save
      flash[:notice] = 'Tape was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @tape  = Tape.find(params[:id])
    @programs = @tape.tape_program_links.find(:all, :order => 'start_time')
    @events = @tape.tape_event_links.find(:all, :order => 'start_time')
  end

  def update
    @tape = Tape.find(params[:id])
     if @tape.update_attributes(params[:tape])
      flash[:notice] = 'Tape was successfully updated'
      redirect_to :action => 'show', :id => @tape
    else
      render :action => 'edit'
    end
  end

  def destroy
    Tape.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def add_event
    @tape_event_link = TapeEventLink.new(params[:tape_event_link])

    if @tape_event_link.save
      flash[:notice] = 'The event was successfully added.'
    end     
    redirect_to :action => 'show',
                  :id => @tape_event_link.tape_id
  end

  def edit_event_link
    @tape_event_link = TapeEventLink.find(params[:id])
  end

  def update_event_link
    @tape_event_link = TapeEventLink.find(params[:id])
    if @tape_event_link.update_attributes(params[:tape_event_link])
      flash[:notice] = 'The event was successfully moved'
      redirect_to :action => 'show', :id => @tape_event_link.tape_id
    else
      render :action => 'edit_event_link'
    end
  end
  
  def remove_event
    @tape_event_link = TapeEventLink.find(params[:id])
    @redirect_id     = @tape_event_link.tape_id
    @tape_event_link.destroy
    flash[:notice] = 'The event was successfully removed'
    redirect_to :action => 'edit',
                :id => @redirect_id  
  end

  def add_program
    @tape_program_link = TapeProgramLink.new(params[:tape_program_link])

    if @tape_program_link.save
      flash[:notice] = 'The program was successfully added.'
    end     
    redirect_to :action => 'show',
                  :id => @tape_program_link.tape_id
  end

  def edit_program_link
    @tape_program_link = TapeProgramLink.find(params[:id])
  end

  def update_program_link
    @tape_program_link = TapeProgramLink.find(params[:id])
    if @tape_program_link.update_attributes(params[:tape_program_link])
      flash[:notice] = 'The program was successfully moved'
      redirect_to :action => 'show', :id => @tape_program_link.tape_id
    else
      render :action => 'edit_program_link'
    end
  end

  def remove_program
    @tape_program_link = TapeProgramLink.find(params[:id])
    @redirect_id     = @tape_program_link.tape_id
    @tape_program_link.destroy
    flash[:notice] = 'The program was successfully removed'
    redirect_to :action => 'edit',
                :id => @redirect_id  
  end



end
