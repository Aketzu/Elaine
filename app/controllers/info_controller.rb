class InfoController < ApplicationController
  skip_before_filter :login_required
  skip_before_filter :require_ssl
  layout nil
  
def playlist
  @channel = Channel.find(:first, :conditions => ["name = ?", params[:id]])
  unless @channel.nil?
    @items = Playlist.find(:all, :conditions => ["channel_id = ?", @channel.id], :order => 'start_time')
  end
end

def next
  @channel = Channel.find(:first, :conditions => ["name = ?", params[:id]])
  unless @channel.nil?
    @items = Playlist.find(:all, :conditions => ["channel_id = ? AND start_time > now()", @channel.id], :order => 'start_time', :limit => 10, :include => [:Program])
  end
end

def gdata
	self.next
end

def vods
  # We assume most vods are past quarantine and thus don't make complicated joins
  #events = Event.find(:all, :conditions => ["quarantine < ?", Time.now])
#  @values = Vod.find_by_sql "SELECT vod_id, max_quarantine FROM (SELECT vods.id AS vod_id, MAX(events.quarantine) AS max_quarantine FROM vods JOIN programs ON vods.program_id = programs.id JOIN program_event_links ON program_event_links.program_id = programs.id JOIN events ON program_event_links.event_id = events.id WHERE vods.completed = true GROUP BY vods.id) AS sub WHERE max_quarantine < NOW();"
#
	if false
  @values = Program.find_by_sql "
		SELECT 
			program_id, 
			max_quarantine 
		FROM (
			SELECT 
				programs.id AS program_id, 
				MAX(events.quarantine) AS max_quarantine 
			FROM programs 
			JOIN program_event_links ON program_event_links.program_id = programs.id 
			JOIN events ON program_event_links.event_id = events.id 
			GROUP BY programs.id) AS sub
		WHERE max_quarantine < NOW() 
			AND (
				SELECT count(*) 
				FROM vods 
				WHERE vods.program_id = sub.program_id) > 0
			AND no_listing != 't'" 
  end

	@values = Program.find_by_sql "
			SELECT 
				programs.id AS program_id
			FROM programs 
			JOIN program_event_links ON program_event_links.program_id = programs.id 
			JOIN events ON program_event_links.event_id = events.id 
			JOIN vods ON vods.program_id = programs.id
			GROUP BY programs.id
			HAVING MAX(events.quarantine) < NOW() 
			" 
			#WHERE (NOT no_listing OR no_listing IS NULL)
	@programs = Program.find(@values.map {|v| v.program_id}, :include => [:Vods, :Events]);

  @langcode = params[:id]
  @language = Language.find(:first, :conditions => ["code = ?", @langcode])
end

end
