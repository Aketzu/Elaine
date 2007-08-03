class InfoController < ApplicationController
  skip_before_filter :login_required
  skip_before_filter :require_ssl
  layout nil
 
#Used for website
def playlist
  @channel = Channel.find(:first, :conditions => ["name = ?", params[:id]])
  unless @channel.nil?
    @items = Playlist.find(:all, :conditions => ["channel_id = ?", @channel.id], :order => 'start_time asc, language_id', :include => [{:Program => [:Events, {:program_descriptions => :Language}]}])
  end
end


def next
  @channel = Channel.find(:first, :conditions => ["name = ?", params[:id]])
  unless @channel.nil?
		#curprog = Playlist.find(:first, :conditions => ["channel_id = ? AND start_time <= now()", @channel.id], :order => 'start_time desc', :include => [{:Program => [:Events, {:program_descriptions => :Language}]}])

    @items = Playlist.find(:all, :conditions => ["channel_id = ? AND start_time > (now() - interval '5 minutes')", @channel.id], :order => 'start_time asc, program_descriptions.language_id ', :limit => 10, :include => [{:Program => [:Events, {:program_descriptions => :Language}]}])
		#@items.insert(0,curprog)
  end
end

#Garo's coming up -flash
def gdata
	self.next
end


def ical
  @channel = Channel.find(:first, :conditions => ["name = ?", params[:id]])
  if @channel.nil? then
		render :text => "Channel not found"
		return
	end
  @items = Playlist.find(:all, :conditions => ["channel_id = ? and (no_listing = false or no_listing is null)", @channel.id], :order => 'start_time', :include => [:Program, {:Program => :Events}])
	@desc = Hash.new
	ProgramDescription.find(:all, :conditions => ["language_id = ?", Language.find_by_code("en")]).each { |d| @desc[d.program_id] = { :title => d.title, :desc => d.public_description } }

	@headers["Content-Type"] = "text/calendar"
	render :layout => false
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
  
	@langcode = params[:id]
  @language = Language.find(:first, :conditions => ["code = ?", @langcode])

	if @language.nil?
		render :text => "Invalid language specified"
		return
	end

	@programs = Program.find(@values.map {|v| v.program_id}, :conditions => [ "language_id = ?", @language.id ], :include => [:ProgramCategory, :program_descriptions, :Events, {:vods => [:VideoFormat, :FileLocation]}]);

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
				obj = Event.find(match[2], :include => :Programs) if match[1] == "e"
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

				if obj.is_a?(Event) then
					obj.Programs.each { |p|
						if p.single_event? then 
							p.file_exists = true
							p.file_status_updated = Time.now
							p.save!
						end
					}
				end

			else
				match = f.match(/.*([0-9]*)_(.*)\.([a-z]*)$/)

				if false and match then
					obj = Vod.find(:first, :conditions => [ "program_id = ? and filename = ?", match[1], match[2] ])
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
