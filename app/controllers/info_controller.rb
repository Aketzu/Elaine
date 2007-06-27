class InfoController < ApplicationController
  skip_before_filter :login_required

def playlist
  @channel = Channel.find(:first, :conditions => ["name = ?", params[:id]])
  unless @channel.nil?
    @items = Playlist.find(:all, :conditions => ["channel_id = ?", @channel.id], :order => 'start_time')
  end
end

def vods
  # We assume most vods are past quarantine and thus don't make complicated joins
  #events = Event.find(:all, :conditions => ["quarantine < ?", Time.now])
  @values = Vod.find_by_sql "SELECT vod_id, max_quarantine FROM (SELECT vods.id AS vod_id, MAX(events.quarantine) AS max_quarantine FROM vods JOIN programs ON vods.program_id = programs.id JOIN program_event_links ON program_event_links.program_id = programs.id JOIN events ON program_event_links.event_id = events.id WHERE vods.completed = true GROUP BY vods.id) AS sub WHERE max_quarantine < NOW();"
  @langcode = params[:id]
  @language = Language.find(:first, :conditions => ["code = ?", @langcode])
end

end
