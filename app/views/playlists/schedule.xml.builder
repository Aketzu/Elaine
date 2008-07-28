xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.schedule do
	@playlists.each { |pl|
		p = pl.program
		xml.entry(:id => p.id) do 
			p.program_descriptions.each { |pd|
				xml.title(pd.title, :lang => pd.lang)
				xml.description(pd.description, :lang => pd.lang)
			}

			xml.start_at(xmldatetime(pl.start_at))
			xml.end_at(xmldatetime(pl.start_at + p.total_target_length))
			xml.length(p.formatted_total_target_length)
		
		end
	}

end
