require 'icalendar'

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


def ical 
  @channel = Channel.find(:first, :conditions => ["name = ?", params[:id]])
  return if @channel.nil?
  @items = Playlist.find(:all, :conditions => ["channel_id = ? ", @channel.id], :order => 'start_time', :include => [:Program])
	desc = Hash.new
	ProgramDescription.find(:all, :conditions => ["language_id = ?", Language.find_by_code("en")]).each { |d| desc[d.program_id] = { :title => d.title, :desc => d.public_description } }

	cal = Icalendar::Calendar.new

	@items.each { |i|
		cal.event do 
			dtstart  DateTime.parse(i.start_time.xmlschema)
			dtend    DateTime.parse(i.end_time.xmlschema)
			dtstamp  DateTime.parse(i.Program.updated_at.xmlschema)
			summary desc[i.program_id][:title].chomp
			description desc[i.program_id][:desc].chomp
			uid	"http://elaine.assembly.org/programs/" + i.program_id.to_s
			#url	"http://elaine.assembly.org/programs/" + i.program_id.to_s
			add_category	i.Program.ProgramCategory.nil? ? "none" : i.Program.ProgramCategory.name 
			location	"none"	
			#UID DTSTART DTEND SUMMARY CATEGORIES LOCATION URL COMMENT
		end
	}

	
	render :text => cal.to_ical
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


def update_files
	return if request.raw_post.nil?

	Event.transaction do

		if params[:full_update] then
			ActiveRecord::Base.connection.execute "UPDATE events SET file_exists = false, file_status_updated = now()"
			ActiveRecord::Base.connection.execute "UPDATE programs SET file_exists = false, file_status_updated = now()"
			ActiveRecord::Base.connection.execute "UPDATE vods SET file_exists = false, file_status_updated = now()"
		end

		request.raw_post.each { |f| 
			match = f.match(/.*([ep])_([0-9]*)_(.*)\.([a-z]*)$/)

			if match then
				obj = nil
				obj = Event.find(match[2]) if match[1] == "e"
				obj = Program.find(match[2]) if match[1] == "p"

				if obj.nil? then
					logger.info "Couldn't find object for " + match[0]
					next
				end

				if obj.filename != match[3] then
					logger.info "Filename mismatch " + obj.filename + " vs. " + match[0]
					next
				end

				obj.file_exists = true
				obj.file_status_updated = Time.now
				obj.save!

			else
				match = f.match(/.*([0-9]*)_(.*)\.([a-z]*)$/)

				if match then
					obj = Vods.find(:first, :conditions => [ "program_id = ? and filename = ?", match[1], match[2] ])
					if obj.nil? then
						logger.info "Couldn't find object for " + match[0]
						next
					end
					obj.file_exists = true
					obj.file_status_updated = Time.now
					obj.save!
					
				end

			end

		}
	end  #Transactions
	
	render :inline => "OK\n"

end

end
