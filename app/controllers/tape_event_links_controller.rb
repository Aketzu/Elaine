class TapeEventLinksController < ApplicationController

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @tape_event_link_pages, @tape_event_links = paginate :tape_event_links, :per_page => 10
  end

  def show
    @tape_event_link = TapeEventLink.find(params[:id])
  end

  def new
    @tape_event_link = TapeEventLink.new
    @events          = Event.find_all
    @tapes           = Tape.find_all
  end

  def create
    @tape_event_link = TapeEventLink.new(params[:tape_event_link])
    if @tape_event_link.save
      flash[:notice] = 'TapeEventLink was successfully created.'
      redirect_to :controller => 'tapes',
                  :action => 'show',
                  :id => @tape_event_link.tape_id
    else
      render :action => 'new'
    end
  end

  def edit
    @tape_event_link = TapeEventLink.find(params[:id])
  end

  def update
    @tape_event_link = TapeEventLink.find(params[:id])
    if @tape_event_link.update_attributes(params[:tape_event_link])
      flash[:notice] = 'TapeEventLink was successfully updated.'
      redirect_to :action => 'show',
                  :id => @tape_event_link
    else
      render :action => 'edit'
    end
  end

  def destroy
    @tape_event_link = TapeEventLink.find(params[:id])
    @redirect_id     = @tape_event_link.tape_id
    @tape_event_link.destroy
    flash[:notice] = 'TapeEventLink was successfully destroyed.'
    redirect_to :controller => 'tapes',
                :action => 'show',
                :id => @redirect_id
  end
end
