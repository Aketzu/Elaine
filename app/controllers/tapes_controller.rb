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
    @event = Event.new
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
    @tape = Tape.find(params[:id])
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

  def add_event
    @tapeevent = TapeEventLink.new(params[:tapeevent])
    @newtape   = Tape.find(@tapeevent.tape_id)
    @newtape.Events << @tapeevent

    redirect_to :action => 'show', :id => @tapeevent.tape_id
  end

  def destroy
    Tape.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
