class LoginController < ApplicationController
require 'net/http'
require 'net/https'

  before_filter :require_no_ssl if (RAILS_ENV == "production")

def index
  http = Net::HTTP.new('intra.assembly.org', 443)
  http.use_ssl = true
  path = '/cgi/livecrew/iglue/login.pl?u=Kjue&p=mcx2798'
  
  # GET request
  resp, data = http.get(path, nil)
  
  @value = (data.to_i == 1)
end

end
