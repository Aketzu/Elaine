class InfoController < ApplicationController
  skip_before_filter :authorize_action

  before_filter :require_no_ssl if (RAILS_ENV == "production")

def playlist
  @channel = Channel.find(:first, :conditions => ["name = ?", params[:id]])
  unless @channel.nil?
    @items = Playlist.find(:all, :conditions => ["channel_id = ?", @channel.id], :order => 'start_time')
  end
end

def vods
  # We assume most vods are past quarantine and thus don't make complicated joins
  #events = Event.find(:all, :conditions => ["quarantine < ?", Time.now])
  @vods = Vod.find(:all) #TODO: Quarantine
  @langcode = params[:id]
  @language = Language.find(:first, :conditions => ["code = ?", @langcode])
end

end