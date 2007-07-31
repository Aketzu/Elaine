class Playlist < ActiveRecord::Base

belongs_to :Program
belongs_to :Channel

validates_associated :Program
validates_associated :Channel

def end_time
  self.start_time + self.Program.length
end

def formatted_length
  self.Program.formatted_length
end

def channel
  Channel.find(self.channel_id)
end

def color
	safety = self.Program.length / 8 % 60
	"#" + hsv_to_rgb((safety < 50 ? safety : 50) / 100.0, 0.70, 0.50)
#   if (self.Program.status == "Production")
#     "green"
#   else
#     "red"
#   end
end

	private
	
		
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

end
