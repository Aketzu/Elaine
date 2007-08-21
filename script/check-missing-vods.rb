#!/usr/bin/ruby

require 'net/http'

def exists(url)
		uri = URI.parse url

		response = nil
		Net::HTTP.start(uri.host, 80) {|http|
			response = http.head(uri.path)
		}
		return true if response.is_a? Net::HTTPOK
		return false if response.is_a? Net::HTTPNotFound
end

Net::HTTP.get(URI.parse('http://elaine.assembly.org/info/vods/en')).each{|l|
	dada = l.match(/.*"(http:\/\/[^ ]*)" .*/)
	if dada then
		p dada[1] unless exists dada[1]
	end
}


