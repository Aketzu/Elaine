class InfoController < ApplicationController
  skip_before_filter :authorize_action

  before_filter :require_no_ssl if (RAILS_ENV == "production")

def playlist
  @channel = Channel.find(:first, :conditions => ["name = ?", params[:id]])
  unless @channel.nil?
    @items = Playlist.find(:all, :conditions => ["channel_id = ?", @channel.id])
  end
end

end