class PlaylistsController < ApplicationController
	require_permission DIRECTOR

  # GET /playlists
  # GET /playlists.xml
  def index
		(redirect_to(channel_playlists_path(DEFAULT_CHANNEL));return) unless params[:channel_id]

		cond = nil
		cond = ['start_at > ?', Time.now - 3600 ] if params[:show_past] != '1'

    @playlists = Playlist.find_all_by_channel_id(params[:channel_id], :include => [:program => [:children, :program_descriptions]], :conditions => cond)
		@playlist = Playlist.new
		@playlist.channel_id = params[:channel_id]
		@playlist.start_at = Playlist.find(:first, :order => 'start_at desc').end_time

		@current = Playlist.for_channel(params[:channel_id]).find(:first, :conditions => [ "start_at < ?", Time.now ], :order => "start_at desc")

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
    @playlist = Playlist.new(params[:playlist])

    respond_to do |format|
      if @playlist.save
        flash[:notice] = 'Playlist was successfully created.'
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
    @playlist = Playlist.find(params[:id])

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

    respond_to do |format|
      format.html { redirect_to(playlists_url) }
      format.xml  { head :ok }
    end
  end
end
