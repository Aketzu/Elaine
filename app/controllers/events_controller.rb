class EventsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @event_pages, @events = paginate :events, 
                                     :per_page => 10
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event   = Event.new
  end

  def create
    @event          = Event.new(params[:event])
    if @event.save
      flash[:notice] = 'Event was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event           = Event.find(params[:id])
    @tape_event_link = TapeEventLink.find(:first, :conditions => ["event_id = ?", @event.id])
    if @event.update_attributes(params[:event]) && @tape_event_link.update_attributes(params[:tape_event_link])
      flash[:notice] = 'Event was successfully updated.'
      redirect_to :action => 'show', :id => @event
    else
      render :action => 'edit'
    end
  end

  def destroy
    Event.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
