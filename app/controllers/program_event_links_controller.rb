class ProgramEventLinksController < ApplicationController

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @program_event_link_pages, @program_event_links = paginate :program_event_links,
                                                        :per_page => 10,
                                                        :order_by => 'program_id',
                                                        :order_by => 'position'
  end

  def edit
    @program_event_link = ProgramEventLink.find(params[:id])
  end

  def new
    @program_event_link = ProgramEventLink.new
  end

  def create
    @program_event_link = ProgramEventLink.new(params[:program_event_link])
    begin
      @program_event_link.event_id = Event.find(:first, :conditions => ['title = ?', params[:event]["title"]]).id
    rescue
        redirect_to(:controller => 'programs',
                    :action => 'edit',
                    :id => @program_event_link.program_id)
    else
      if @program_event_link.save
        flash[:notice] = 'ProgramEventLink was successfully created.'
        redirect_to :controller => 'programs',
                    :action => 'edit',
                    :id => @program_event_link.program_id
      else
        render :action => 'new'
      end
    end
  end

  def edit
    @program_event_link = ProgramEventLink.find(params[:id])
  end

  def update
    @program_event_link = ProgramEventLink.find(params[:id])
    if @program_event_link.update_attributes(params[:program_event_link])
      flash[:notice] = 'ProgramEventLink was successfully updated.'
      redirect_to :action => 'edit', :id => @program_event_link
    else
      render :action => 'edit'
    end
  end

  def destroy
    @program_event_link = ProgramEventLink.find(:first, :conditions => ["program_id = ? and event_id = ?", params[:program_id], params[:event_id]])
    @redirect_id     = @program_event_link.program_id
    @program_event_link.destroy
    flash[:notice] = 'ProgramEventLink was successfully destroyed.'
    redirect_to :controller => 'programs',
                :action => 'edit',
                :id => @redirect_id
  end
end
