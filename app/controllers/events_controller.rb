class EventsController < ApplicationController
  sidebar :general

  auto_complete_for :event, :title

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    session[:original_uri] = request.request_uri

    unless params.nil?
      unless params[:search].nil?
        @filter = params[:search]
      end
      unless params[:event].nil?
        @filter = params[:event][:title]
      end
    end

    if @filter.nil?
      @event_pages, @events = paginate :events, 
                                       :per_page => 20
    else
      @event_pages, @events = paginate(:events, 
                                       :per_page => 20,
                                       :conditions => ["title ILIKE ?", 
                                                       '%' + @filter + '%'])
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event   = Event.new
    @event.EventType = EventType.find(:first, :conditions => ['name = ?', 'insert'])
    #TODO: Change the database default to 'insert'.
  end

  def create
    @event          = Event.new(params[:event])
    if @event.save
      flash[:notice] = 'Event was successfully created.'
      redirect_to :action => 'edit', :id => @event.id
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
    if @event.update_attributes(params[:event]) && 
       (@tape_event_link.nil? || @tape_event_link.update_attributes(params[:tape_event_link]))
      flash[:notice] = 'Event was successfully updated.'
      redirect_to :action => 'edit', :id => @event
    else
      render :action => 'edit'
    end
  end

  def destroy
    Event.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
