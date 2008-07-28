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
					#FIXME
					#url = program.vods.first.FileLocation.url
					url = "http://foo/"

					xml.media(:thumbnail, :url => url + program.id.to_s + '_' + program.filename + '_preview.jpg') # TODO: store dimensions
					# TODO: Use an explicit join to include the relevant formats in the initial select for the collection
					for vod in program.vods
						xml.media(:content, :duration => vod.length, :url => url + vod.filename, :fileSize => vod.filesize.to_s, :bitrate => vod.vod_format.vbitrate.to_s, :type => vod.vod_format.mime_type, :expression => "full")
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
