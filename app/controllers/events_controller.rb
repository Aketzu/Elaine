class EventsController < ApplicationController
  sidebar :general

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

    @filter ||= params[:search]
    @filter ||= params[:event][:title] unless params[:event].nil?
    @filter ||= ""

    unless @filter.empty?
      @search += " AND events.title ILIKE :title "
      @searchparams[:title] = "%#{@filter}%"
    end

    unless params[:ignore_date_filter]
      @search += " AND events.created_at > :created_at "
      @searchparams[:created_at] = @date_filter = self.current_user.content_filter_date
    end

  end

  def list
    session[:original_uri] = request.request_uri

		buildsearch

    @event_pages, @events = paginate(:events, 
                                     :per_page => 20,
                                     :conditions => [@search, @searchparams])
		if request.xml_http_request?
			render :partial => "list", :layout => false
		end
  end

	#def auto_complete_for_program_description_title
	def auto_complete_for_event_title
		buildsearch

		@items = Event.find(:all, :order => 'title', :conditions => [@search, @searchparams])
		render :inline => "<%= auto_complete_result @items, 'title' %>"
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
