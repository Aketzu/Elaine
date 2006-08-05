class EventsController < ApplicationController
  sidebar :general

  auto_complete_for :event, :title
  auto_complete_for :location, :name
  auto_complete_for :event_type, :name

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

    @title    = ""
    @location = ""
    @type     = ""

    @title    = params[:event][:title] unless params[:event].nil?
    @location = params[:location][:name] unless params[:location].nil?
    @type     = params[:event_type][:name] unless params[:event_type].nil?

    if @title.nil? and @location.nil? and @type.nil?
      @event_pages, @events = paginate :events, 
                                       :per_page => 20
    else
      @events = Event.find_by_sql(['SELECT * FROM events e, locations l, event_types t ' +
                                   'WHERE l.id = e.location_id AND t.id = e.event_type_id ' +
                                     'AND e.title LIKE ? AND l.name LIKE ? AND t.name LIKE ?',
                                   '%' + @title + '%', '%' + @location + '%', '%' + @type + '%'])
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
