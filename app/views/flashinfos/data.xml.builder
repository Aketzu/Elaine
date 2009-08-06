xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.comingup do
	xml.programs do 
		xml.program(:type => "now") do
			if @current
				xml.time(@current.start_at.strftime("%H:%M"))
				xml.title(@current.program.title)
				xml.description(@current.program.description)
			else
				xml.time "-"
				xml.title "Nothing"
				xml.description "Nothing running at the moment"
			end
		end
		type="next"
		@playlists.each { |pl|
			next unless pl.start_at
			logger.info (pl.start_at - Time.now)
			next if (pl.start_at - Time.now) > (18*60*60)
			xml.program(:type => type) do
				xml.time(pl.start_at.strftime("%H:%M"))
				xml.title(pl.program.title)
				xml.description(pl.program.description)
				type="comingup"
			end
		}

	end
	xml.info @infos[F_Infotext]
	xml.bgm @infos[F_BGMusic]
	xml.bgImg @infos[F_BGImage]
	xml.images do 
		@infos.each { |k,v|
			next unless k.start_with? F_ImageN
			next if v.empty?
			xml.image v
		}
	end

	xml.views do
		@infos.each { |k,v|
			next unless k.start_with? F_ViewN
			next if v.empty?
			id = k[4..99]
			xml.view(:id => id) do
				case v[-3..-1]
					when "swf":
						xml.flash v
					#when "jpg":
					#when "png":
					else
						xml.image v
				end
			end
		}
	end

end
