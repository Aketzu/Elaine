class InfoController < ApplicationController

def playlist
  @channel = Channel.find(params[:id])
  @items = Playlist.find(:all, :conditions => ["channel_id = ?", @channel.id])
end

end