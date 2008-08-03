xml.instruct! :xml, :encoding => "ISO-8859-1"
xml.data("protocol-version" => "1.6") do
	xml.event(:type => :flashscreen, :target => :production) do
		xml.screen(:type => :ohjelmisto) do
			xml.title(@playlists.first.channel.name)
			@playlists.each { |item|
				program = item.program
				unless program
					xml.body("", :time => "")
					
					next
				end
				xml.body(:time => item.start_at.strftime("%H%M")) do
					xml.cdata!(program.title + "  ")
				end
			}

			xml.config() do
				xml.margin(100)
			end
		end

		xml.screen(:type => :seuraava) do
			item = @playlists.first
			xml.title(item.channel.name + " Next")
			program = item.program
			xml.body() do
			xml.cdata!(program.title + "  ")
		end

		xml.config() do
			xml.margin(100)
		end
	end

	xml.view(0)

	end
end
