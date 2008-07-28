module PlaylistsHelper
	def xmldatetime(time)
		time.strftime("%Y-%m-%dT%H:%M:%S")
	end
end
