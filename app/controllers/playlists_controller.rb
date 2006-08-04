class PlaylistsController < ApplicationController
  layout 'application', :except => [:timeline_xml, :timeline_config, :bandinfo_xml]
  sidebar :general

  before_filter :require_no_ssl if (RAILS_ENV == "production")

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @channel_id = params[:channel_id].to_i
    if(@channel_id == 0)
      @channel_id = Channel.find(:first).id
    end
    @now = Time.now
    @playlist = Playlist.new
    @playlist.start_time = Playlist.find(:first, :order => 'start_time desc').end_time
    if @playlist.start_time < @now
      @playlist.start_time = @now
    end
    @playlist.start_time += (60 - @playlist.start_time.to_i % 60)

    @channels = Channel.find(:all)
    @playlists = Playlist.find(:all, :conditions => ["channel_id = ?", @channel_id], :order => 'start_time')
  end

  def show
    @playlist = Playlist.find(params[:id])
  end

  def timeline
    list
    @timeline = true
    @broadcast_log = BroadcastLog.new()
    @broadcast_log.channel_id = @channel_id
    @playlists = Playlist.find(:all, :conditions => ["channel_id = ?", @channel_id], :order => 'start_time')
  end

  def timeline_xml
    @channel_id = params[:channel_id].to_i
    if(@channel_id == 0)
      @channel_id = Channel.find(:first).id
    end
    @playlists = Playlist.find(:all, :conditions => ["channel_id = ?", @channel_id], :order => 'start_time')
    @show_events = params[:show_events]
  end

  def timeline_config
    timeline_xml
    @now1 = Time.now
    @now2 = Time.now + 60
  end

  def new
    @playlist = Playlist.new
  end

  def fix_by_moving
    @playlist = Playlist.find(params[:id])
    @playlist.start_time += params[:difference].to_i
    @playlist.start_time += (60 - @playlist.start_time.to_i % 60)
    @playlist.save
    list
    redirect_to(:action => 'index') unless request.xhr?
  end

  def pick_time
    @playlist = Playlist.find(params[:id])
    @playlist.start_time = params[:end_time]
    @playlist.start_time += 60
    @playlist.movable = true
  end

  def add_to_playlist
    @playlist = Playlist.new(params[:playlist])
    @saved = @playlist.save
    list
    redirect_to(:action => 'index') unless request.xhr?
  end

  def edit
    @playlist = Playlist.find(params[:id])
    @channel_id = params[:channel_id].to_i
    if(@channel_id == 0)
      @channel_id = Channel.find(:first).id
    end
  end

  def update
    @playlist = Playlist.find(params[:id])
    if @playlist.update_attributes(params[:playlist])
      flash[:notice] = 'Playlist was successfully updated.'
      redirect_to(:action => 'list', :channel_id => @playlist.channel_id)
    else
      render :action => 'edit'
    end
  end

  def destroy
    Playlist.find(params[:id]).destroy
    list
  end
end
