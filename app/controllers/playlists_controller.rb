class PlaylistsController < ApplicationController
  layout 'application', :except => [:timeline_xml, :timeline_config, :bandinfo_xml]

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
    @channels = Channel.find(:all)
    @playlist_pages, @playlists = paginate :playlists, :per_page => 10, :conditions => ["channel_id = ?", @channel_id], :order => 'start_time'
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
    @playlist = Playlist.find_all
  end

  def timeline_xml
    @playlist = Playlist.find_all
  end

  def timeline_config
    @channels = Channel.find(:all)
    @channel_id = params[:channel_id].to_i
    if(@channel_id == 0)
      @channel_id = Channel.find(:first).id
    end
    @playlist_pages, @playlists = paginate :playlists, :per_page => 10, :conditions => ["channel_id = ?", @channel_id], :order => 'start_time'
  end

  def new
    @playlist = Playlist.new
  end

  def create
    @playlist = Playlist.new(params[:playlist])
    if @playlist.save
      flash[:notice] = 'Playlist was successfully created.'
      redirect_to :action => 'list', :channel_id => @playlist.channel_id
    else
      render :action => 'new'
    end
  end

  def edit
    @playlist = Playlist.find(params[:id])
  end

  def update
    @playlist = Playlist.find(params[:id])
    if @playlist.update_attributes(params[:playlist])
      flash[:notice] = 'Playlist was successfully updated.'
      redirect_to :action => 'list', :channel_id => @playlist.channel_id
    else
      render :action => 'edit'
    end
  end

  def destroy
    Playlist.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
