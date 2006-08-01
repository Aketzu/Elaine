class InfoController < ApplicationController
  skip_before_filter :authorize_action

def playlist
  @channel = Channel.find(:first, :conditions => ["name = ?", params[:id]])
  unless @channel.nil?
    @items = Playlist.find(:all, :conditions => ["channel_id = ?", @channel.id])
  end
end

end