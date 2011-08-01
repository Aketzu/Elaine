# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  #include UserEngine
  #include TimeHelper

	def indexed_auto_complete_result(entries, entityType, field, index)
		return unless entries
		items = entries.map { |entry| content_tag("li", entry[field], "id" => entityType+'::'+entry[index].to_s) }
		content_tag("ul", items.uniq)
	end

	def tooltip(text)
		image_tag('tooltip.png', :onmouseover => 'Tip("' + text + '")')
	end

	def tooltip_collapsable
		image_tag('tooltip.png', :onmouseover => 'Tip("This is a collapsable rowgroup.")')
	end

	def tooltip_format_time
		image_tag('tooltip.png', :onmouseover => 'Tip("Format: hh:mm:ss<br/>You can omit zeros from the beginning of the string.")')
	end

	def sortlink(title, column)
		link_to title, params.merge({:sort => column, :order => ((params[:sort] == column.to_s && params[:order] == 'asc') ? 'desc' : 'asc') })
	end
	
	# Use float values ranging between 0.0 - 1.0
	def hsv_to_rgb(hue, saturation, value)
		# calculate rgb values from hsv floats
		if saturation == 0
			r = g = b = value
		else
			hue = hue * 6
			hue = 0 if hue == 6
			
			var_i = hue.floor
			var_1 = value * ( 1 - saturation )
			var_2 = value * ( 1 - saturation * ( hue - var_i ) )
			var_3 = value * ( 1 - saturation * ( 1 - ( hue - var_i ) ) )

			r, g, b = case var_i
			when 0
				[value, var_3, var_1]
			when 1
				[var_2, value, var_1]
			when 2
				[var_1, value, var_3]
			when 3
				[var_1, var_2, value]
			when 4
				[var_3, var_1, value]
			else
				[value, var_1, var_2]
			end
		end
		# convert rgb values to base 255 (8-bit) values
		r = (r * 255.0).round
		g = (g * 255.0).round
		b = (b * 255.0).round
		if r > 255
			r = 255
		end
		if g > 255
			g = 255
		end
		if b > 255
			b = 255
		end

		return (r.to_s(16).length > 1 ? r.to_s(16) : "0"+r.to_s(16)) + 
						(g.to_s(16).length > 1 ? g.to_s(16) : "0"+g.to_s(16)) + 
						(b.to_s(16).length > 1 ? b.to_s(16) : "0"+b.to_s(16))
	end

	def elaine_version
		return @elaine_version if @elaine_version
		File.open(".git/refs/heads/master", "r") { |f|
			@elaine_version = f.gets[0..8]
		}
=begin SVN rev
		File.open(".svn/entries", "r") { |f|
			3.times do
				f.gets
			end
			@elaine_version = "r" + f.gets.chomp
		}
=end
		return @elaine_version 
	end

	def format_length(length)
    unless length.nil?
      total_minutes, seconds = length.divmod(60)
      total_hours, minutes   = total_minutes.divmod(60)
      days, hours            = total_hours.divmod(24)
      if(days > 0)
        sprintf("%d day %02d:%02d:%02d", days, hours, minutes, seconds)
      else
        sprintf("%02d:%02d:%02d", hours, minutes, seconds)
      end
    else
      sprintf("")
    end
  end

  def parse_formatted_length(formatted)
    hours = formatted[0,2]
    minutes = formatted[3,2]
    seconds = formatted[6,2]
    if( (not formatted.nil?) && (formatted.length == 8) )
      ((((hours.to_f * 60.0) + minutes.to_f) * 60.0) + seconds.to_i).to_i
    else
      nil
    end
  end

	def tickimage(val)
		image_tag 'icons/' + (val ? 'tick' : 'cross') + '.png', :alt => (val ? 'Yes' : 'No')
	end

end
