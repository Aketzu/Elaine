class LoginController < ApplicationController

def index
require 'net/http'
require 'net/https'

http = Net::HTTP.new('intra.assembly.org', 443)
http.use_ssl = true
path = '/cgi/livecrew/iglue/login.pl?u=late&p=test'

# GET request
resp, data = http.get(path, nil)

@value = data
end

end
