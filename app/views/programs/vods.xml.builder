xml.instruct! :xml, :encoding => "ISO-8859-1"
xml.rss(:version => "2.0", :'xmlns:media' => "http://search.yahoo.com/mrss") do
	xml.channel do
		xml.title("Assembly VOD")
		xml.description("VOD files of Assembly TV programs, compos and seminars")
		xml.link # TODO: Point this to what?
		xml.pubDate(xmldatetime(Time.now))
		xml.ttl("5")
		for program in @programs
			xml.item do
				#desc = program.program_descriptions.find(:first, :conditions => ["language_id = ?", @language.id])
				desc = program.program_descriptions.first

				xml.title(desc.title, :'xml:lang' => desc.lang)
				xml.description((desc.description || "").gsub(/[\n\r]/,''), :'xml:lang' => desc.lang)      
				xml.link # TODO: Additional info is where?
				xml.pubDate(xmldatetime(program.updated_at))
				 # TODO: Hardcoded host and proto
				xml.guid("http://elaine.assembly.org" + url_for(program))
				xml.media(:group) do
					base = (program.vods.first.full_path || "").gsub /\/[^\/]*$/, "/"
					xml.media(:thumbnail, :url => base + program.id.to_s + '_' + program.filename + '_preview.jpg')
					for vod in program.vods
						xml.media(:content, :duration => vod.length, :url => vod.full_path, :fileSize => vod.filesize.to_s, :bitrate => vod.vod_format.vbitrate.to_s, :type => vod.vod_format.mime_type, :expression => "full")
					end
				end
				xml.category("Assembly")
				xml.category("video")
				# TODO: Set of nasty assumption hacks
				xml.category(program.program_category.name) unless program.program_category.nil?
			end
		end
	end
end
