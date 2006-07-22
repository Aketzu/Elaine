class PlaylistsController < ApplicationController
  layout 'application', :except => [:timeline_xml, :timeline_config, :bandinfo_xml]

  def index
    playlist
    render :action => 'playlist'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @channel_id = params[:channel_id].to_i
    if(@channel_id == 0)
      @channel_id = Channel.find(:first).id
    end
    @channels = Channel.find(:all)
    @playlist_pages, @playlists = paginate :playlists, :per_page => 10, :conditions => ["channel_id = ?", @channel_id], :order => 'start_time'
  end

  def playlist
    @channel_id = params[:channel_id].to_i
    if(@channel_id == 0)
      @channel_id = Channel.find(:first).id
    end
    @channels = Channel.find(:all)
    @playlists = Playlist.find(:all, :conditions => ["channel_id = ?", @channel_id], :order => 'start_time')
  end

  def show
    @playlist = Playlist.find(params[:id])
  end

  def timeline
    @timeline = true
    @channel_id = params[:channel_id].to_i
    if(@channel_id == 0)
      @channel_id = Channel.find(:first).id
    end
    @playlist_pages, @playlists = paginate :playlists, :per_page => 10, :conditions => ["channel_id = ?", @channel_id], :order => 'start_time'
  end

  def timeline_xml
    @channel_id = params[:channel_id].to_i
    if(@channel_id == 0)
      @channel_id = Channel.find(:first).id
    end
    @playlist_pages, @playlists = paginate :playlists, :per_page => 10, :conditions => ["channel_id = ?", @channel_id], :order => 'start_time'
  end

  def timeline_config
    @now = Time.now
    @channel_id = params[:channel_id].to_i
    if(@channel_id == 0)
      @channel_id = Channel.find(:first).id
    end
    @playlist_pages, @playlists = paginate :playlists, :per_page => 10, :conditions => ["channel_id = ?", @channel_id], :order => 'start_time'
  end

  def new
    @playlist = Playlist.new
  end

  def fix_overlap
    @playlist = Playlist.find(params[:id])
    @playlist.start_time += params[:difference].to_i
    @playlist.save
    playlist
  end

  def add_to_playlist
    @playlist = Playlist.new(params[:playlist])
    @playlist.save
    playlist
  end

  def edit
    @playlist = Playlist.find(params[:id])
  end

  def update
    @playlist = Playlist.find(params[:id])
    if @playlist.update_attributes(params[:playlist])
      flash[:notice] = 'Playlist was successfully updated.'
      redirect_to(:action => 'playlist', :channel_id => @playlist.channel_id)
    else
      render :action => 'edit'
    end
  end

  def destroy
    Playlist.find(params[:id]).destroy
    playlist
  end
end
