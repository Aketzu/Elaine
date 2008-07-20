#!/usr/bin/ruby
require 'rubygems'
require 'postgres'

conn = PGconn.connect("localhost", 5433, '', '', 'akolehma', 'akolehma', 'foo')

#Botched local DB
conn.set_client_encoding("UTF-8")
@conn = conn


def dump_tbl(table, old_table = table, &procs)
	File.open(table + ".yml", "w") { |f|
		res = @conn.exec('select * from ' + old_table + ' order by 1')
		res.each { |row|
			@curid = id = row["id"]

			f.write "#{table}-#{id}:\n"
			row.each { |name,val|

				#next if name == 'description'
				(name, val) = yield(name, val)

				next if name == nil
				val ||= "";

				val.strip!
				val.gsub! "\"", "\\\""
				f.write "  #{name}: \"#{val}\"\n"
			}
		}
	}

end

def new_tbl(table, data)
	File.open(table + ".yml", "w") { |f|
		data.each { |row|
			id = row.hash
			f.write "#{table}-#{id}:\n"
			row.each { |name, val|
				val ||= "";
				val = val.to_s
				val.strip!
				val.gsub! "\"", "\\\""
				f.write "  #{name}: \"#{val}\"\n"
			}
		}
	}

end


dump_tbl("channels") { |name, val|
	next if name == 'description'
	[name, val]
}

dump_tbl("program_categories") { |name, val|
	next if name == 'vod_group_id'
	[name, val]
} 


#Fetch all programs & events & links
#if exactly one event for program then merge data
#if multiple events per program then leave program as parent and create
# subprograms from events

events = Hash.new

res = @conn.exec('select * from events order by 1')
res.each { |row|
	r = Hash.new
	row.each { |name,val|
		r[name] = val
	}
	events[row["id"]] = r
}

programs = Hash.new

res = @conn.exec('select max(id) from programs')
@maxid = res[0][0].to_i+1

res = @conn.exec('select * from programs order by 1')
res.each { |row|
	r = Hash.new
	row.each { |name,val|
		next if name == "min_show" || name == "max_show" || name == "preview_video_offset" || name == "file_location_id"|| name == "tags" || name == "video_format_id"

		name = "pms_id" if name == "external_id"

		if name == "status_id"
			name = "status"
			val = case val
				when "1"; "Planning"
				when "2"; "Production"
				when "3"; "Done"
				else; ""
				end
		end
		#if name == "owner_id"
		#	@programs_users << {:program_id => row["id"], :user_id => val, :usertype => "Owner"}
		#	next
		#end

		r[name] = val
	}
	programs[row["id"]] = r
}

program_event_links = Hash.new
res = @conn.exec('select * from program_event_links order by 2,1')
res.each { |row|
	id = row["program_id"]
	program_event_links[id] ||= Array.new
	program_event_links[id] << events[row["event_id"]]
}

newprograms = Array.new
progdesc = Array.new
maxdescid = 0
res = @conn.exec('select * from program_descriptions order by 1')
res.each { |row|
	r = Hash.new
	row.each { |name,val|
		next if name == 'private_description' || name == "position"
		name = "description" if name == "public_description"

		if name == "language_id"
			name = "lang"
			val = case val
				when "1"; "en"
				when "2"; "fi"
				else; ""
			end
		end
		r[name] = val
	}
	maxdescid = row["id"].to_i if row["id"].to_i > maxdescid
	progdesc << r
}
programs.each { |pid, prog| 
	if program_event_links[pid] == nil || program_event_links[pid].length == 0
		#Do nothing, all is good
		newprograms << prog
	elsif program_event_links[pid].length == 1
		#Update data
		event = program_event_links[pid][0]
		prog["notes"] ||= ""
		prog["notes"] += "\n" + event["notes"] if event["notes"]
		prog["notes"] += "\n" + event["script"] if event["script"]
		prog["target_length"] ||= event["length"]
		#FIXME: Lengths are not correct always
		prog["filename"] ||= event["filename"]
		prog["quarantine"] = event["quarantine"]
		prog["pms_id"] ||= event["external_id"]
		prog["programtype"] = case event["event_type_id"]
			when "1"; "Live"
			when "2"; "Insert"
			end

		newprograms << prog
	else # >1
		progtype = program_event_links[pid][0]["event_type_id"]

		program_event_links[pid].each { |event|
			newprog = prog.dup
			newprog["id"] = @maxid
			@maxid = @maxid + 1
			newprog["program_id"] = pid
			maxdescid = maxdescid + 1
			progdesc << { :id => maxdescid, :program_id => newprog["id"], :lang => :en, :title => event["title"] }	

			newprog["notes"] += "\n" + event["notes"] if event["notes"]
			newprog["notes"] += "\n" + event["script"] if event["script"]
			newprog["target_length"] ||= event["length"]
			newprog["filename"] ||= event["filename"]
			newprog["quarantine"] = event["quarantine"]
			newprog["pms_id"] ||= event["external_id"]
			newprog["programtype"] = case event["event_type_id"]
				when "1"; "Live"
				when "2"; "Insert"
				end
			progtype = 3 if progtype != event["event_type_id"]

			newprograms << newprog

		}
		prog["programtype"] = case progtype
			when "1"; "Live"
			when "2"; "Insert"
			when "3"; "Insert+Live"
			end

		newprograms << prog
	end

}


new_tbl("programs", newprograms)
#new_tbl("programs_users", @programs_users)
new_tbl("program_descriptions", progdesc)

dump_tbl("playlists") { |name, val|
	next if name == 'no_listing'
	name = "start_at" if name == "start_time"

	[name, val]
}
dump_tbl("programs_tapes", "tape_program_links") { |name, val|
	name = "start_at" if name == "start_time"

	[name, val]
}
dump_tbl("tapes") { |name, val|
	next if name == 'owner_id' || name == 'media_id' || name == 'category_id'

	[name, val]
}

user_roles = Hash.new
res = @conn.exec('select * from users_roles')
res.each { |row|
	id = row["user_id"]
	user_roles[id] ||= Array.new
	user_roles[id] << row["role_id"]
}
require '../../../config/initializers/elaine.rb'

dump_tbl("users") { |name, val|
	#TODO: permissions 
	#TODO: any of these needed?
	next if name == 'verified' || name == 'language' || name == 'content_filter_date' || name == 'channel_id'

	if name == "firstname"
		@name = val
		next
	end
	if name == "lastname"
		val = @name + " " + val if @name
		name = "name"
	end

	if name == "role"
		name = "level"
		val = 0
		user_roles[@curid].each { |r|
			case r.to_i
				when 2; v = ADMIN
				when 1; v = GUEST
				when 4; v = REPORTER
				when 7; v = REPORTER
				when 5; v = DIRECTOR
				when 3; v = GUEST
				else; v = DISABLED
			end
			val = v if v > val
		}
		val = val.to_s
	end

	[name, val]
}
dump_tbl("vod_formats", "video_formats") { |name, val|
	next if name == 'description' || name == 'use_for_vods' || name == 'use_for_production'

	[name, val]
}
dump_tbl("vods") { |name, val|
	next if name == 'file_location_id' || name == 'completed' || name == 'file_exists' || name == 'file_status_updated'

	name = "vod_format_id" if name == "video_format_id"

	[name, val]
}
