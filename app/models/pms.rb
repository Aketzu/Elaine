class Pms
	include HTTParty
	base_uri 'http://pms.asm.fi/api/'
	basic_auth 'elaine', '33lainee!'


	def parties
		self.class.get('/parties/')
	end

	def compos(party)
		self.class.get("/party/#{party}/compos/")
	end

	def entries(party, compo)
		self.class.get("/party/#{party}/compo/#{compo}/entries/")
	end
	
end
