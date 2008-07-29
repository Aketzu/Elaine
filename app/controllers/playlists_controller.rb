class PlaylistsController < ApplicationController
	require_permission REPORTER

  # GET /playlists
  # GET /playlists.xml
  def index
		(redirect_to(channel_playlists_path(DEFAULT_CHANNEL));return) unless params[:channel_id]

		cond = nil
		cond = ['start_at > ?', Time.now - 3600 ] if params[:show_past] != '1'

    @playlists = Playlist.find_all_by_channel_id(params[:channel_id], :include => [:program => [:children, :program_descriptions]], :conditions => cond, :order => :start_at)
		@playlist = Playlist.new
		@playlist.channel_id = params[:channel_id]
		@playlist.start_at = Playlist.find(:first, :order => 'start_at desc').end_time || Time.now
		@playlist.start_at += (60 - @playlist.start_at.to_i % 60)

		@current = Playlist.for_channel(params[:channel_id]).find(:first, :conditions => [ "start_at < ?", Time.now ], :order => "start_at desc")

		@current ||= Playlist.new

		(render :partial => "playlists"; return) if request.xhr?

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @playlists }
    end
  end

  # GET /playlists/1
  # GET /playlists/1.xml
  def show
    @playlist = Playlist.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @playlist }
    end
  end


	def timeline
    respond_to do |format|
      format.html # show.html.erb
      #format.xml  { render :xml => @playlist }
    end
	end

	skip_before_filter :login_required, :only => [:schedule, :next]
	skip_before_filter :check_auth, :only => [:schedule, :next]

	caches_page :schedule

	def next
		@playlists = Playlist.for_channel(params[:channel_id]).find(:all, :include => [:program => [:children, :program_descriptions]], :order => :start_at,
			:limit => 10, :conditions => ["start_at > (now() - interval 5 minute)"])

		render :action => :schedule
	end

	def schedule
		return unless params[:channel_id]
   	
		@playlists = Playlist.for_channel(params[:channel_id]).find(:all, :include => [:program => [:children, :program_descriptions]], :order => :start_at)
		
    respond_to do |format|
      #format.html
      format.xml  { render :xml => @playlist }
      format.ics  #{ render :xml => @playlist }
    end
	end
	
	def gdata
		return unless params[:channel_id]
    
		@playlists = Playlist.for_channel(params[:channel_id]).find(:all,
			:conditions => ["start_at > (now() - interval 5 minute)"],
			:include => [:program => [:children, :program_descriptions]],
			:order => :start_at,
			:limit => 10)
		
    respond_to do |format|
      #format.html
      format.xml  { render :xml => @playlist }
    end
	end

  # GET /playlists/new
  # GET /playlists/new.xml
  def new
    @playlist = Playlist.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @playlist }
    end
  end

  # GET /playlists/1/edit
  def edit
    @playlist = Playlist.find(params[:id])
  end

  # POST /playlists
  # POST /playlists.xml
  def create
		params[:playlist].delete :program
    @playlist = Playlist.new(params[:playlist])
		params[:channel_id] = @playlist.channel_id
	
		require_permission(DIRECTOR) || return
		
		expire_page schedule_channel_playlists_path(@playlist.channel_id)
		expire_page formatted_schedule_channel_playlists_path(@playlist.channel_id, :xml)

    respond_to do |format|
      if @playlist.save
        flash[:notice] = 'Playlist was successfully created.'
				(index; return) if request.xhr?
        format.html { redirect_to(channel_playlists_path(@playlist.channel_id)) }
        format.xml  { render :xml => @playlist, :status => :created, :location => @playlist }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @playlist.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /playlists/1
  # PUT /playlists/1.xml
  def update
		params[:playlist].delete :program
    @playlist = Playlist.find(params[:id])

		expire_page schedule_channel_playlists_path(@playlist.channel_id)
		expire_page formatted_schedule_channel_playlists_path(@playlist.channel_id, :xml)
		
		require_permission(DIRECTOR) || return

    respond_to do |format|
      if @playlist.update_attributes(params[:playlist])
        flash[:notice] = 'Playlist was successfully updated.'
        format.html { redirect_to(channel_playlists_path(@playlist.channel_id)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @playlist.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /playlists/1
  # DELETE /playlists/1.xml
  def destroy
    @playlist = Playlist.find(params[:id])
    @playlist.destroy
		params[:channel_id] = @playlist.channel_id
		
		expire_page schedule_channel_playlists_path(@playlist.channel_id)
		expire_page formatted_schedule_channel_playlists_path(@playlist.channel_id, :xml)
		
		require_permission(DIRECTOR) || return
				
		(index; return) if request.xhr?

    respond_to do |format|
      format.html { redirect_to(playlists_url) }
      format.xml  { head :ok }
    end
  end
end
