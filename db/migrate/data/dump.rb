#!/usr/bin/ruby
require 'rubygems'
require 'postgres'

conn = PGconn.connect("localhost", 5433, '', '', 'akolehma', 'akolehma', '')

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

@programs_users = Array.new

#BIG TODO: events migration

#Fetch all programs & events & links
#if exactly one event for program then merge data
#if multiple events per program then leave program as parent and create
# subprograms from events

dump_tbl("programs") { |name, val|
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

	if name == "owner_id"
		@programs_users << {:program_id => @curid, :user_id => val, :usertype => "Owner"}
		next
	end

	[name, val]
}

new_tbl("programs_users", @programs_users)

dump_tbl("program_descriptions") { |name, val|
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
	[name, val]
}
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
dump_tbl("users") { |name, val|
	#TODO: permissions 
	#TODO: any of these needed?
	next if name == 'verified' || name == 'role' || name == 'content_filter_date' || name == 'language' || name == 'channel_id'

	if name == "firstname"
		@name = val
		next
	end
	if name == "lastname"
		val = @name + " " + val if @name
		name = "name"
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
