class BroadcastLogsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  before_filter :require_no_ssl if (RAILS_ENV == "production")

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @channel_id = params[:channel_id].to_i
    if(@channel_id == 0)
      @channel_id = Channel.find(:first).id
    end  
    @broadcast_log_pages, @broadcast_logs = paginate :broadcast_logs, :per_page => 10, :conditions => ["channel_id = ?", @channel_id], :order => 'start_time'
  end

  def show
    @broadcast_log = BroadcastLog.find(params[:id])
  end

  def new
    @channel_id = params[:channel_id].to_i
    @broadcast_log = BroadcastLog.new
  end

  def create
    @broadcast_log = BroadcastLog.find(:first, 
      :conditions => ["program_id = ? AND channel_id = ? AND start_time = ?", 
                      params[:program_id], 
                      params[:channel_id], 
                      params[:start_time]])
    @saved = nil
    if @broadcast_log.nil?
      @broadcast_log = BroadcastLog.new
      @broadcast_log.program_id = params[:program_id]
      @broadcast_log.channel_id = params[:channel_id]
      @broadcast_log.start_time = params[:start_time]
      @saved = @broadcast_log.save
    end
  end

  def edit
    @broadcast_log = BroadcastLog.find(params[:id])
  end

  def update
    @broadcast_log = BroadcastLog.find(params[:id])
    if @broadcast_log.update_attributes(params[:broadcast_log])
      flash[:notice] = 'BroadcastLog was successfully updated.'
      redirect_to :action => 'show', :id => @broadcast_log
    else
      render :action => 'edit'
    end
  end

  def destroy
    if @broadcast_log = BroadcastLog.find(:first, 
        :conditions => ["program_id = ? AND channel_id = ? AND start_time = ?", 
                        params[:program_id], 
                        params[:channel_id], 
                        params[:start_time]])
      @success = true if @broadcast_log.destroy
    end
  end
end
