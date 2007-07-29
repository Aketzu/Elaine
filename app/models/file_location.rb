class FileLocation < ActiveRecord::Base

has_many :Events
has_many :Programs
has_many :Vods

def exists?(filename)
	#Not used anymore
	return false

  begin
    url = URI.parse(self.checker_url)
    logger.info url

    req = Net::HTTP::Get.new(url.path  + '?filename=' + filename)
    logger.info req

    res = Net::HTTP.start(url.host, url.port) {|http|
       http.request(req)
    }
    result = res.body.to_s
    logger.info result

    if(result == "true")
      true
    else
      false
    end
  rescue 
    logger.info "Rescued HTTP request."
    return false
  end
  #logger.info "Congratulations! No errors!"
end

def works?
  if(self.exists?("test") and !self.exists?(" "))
    true
  else
    nil
  end
end

end
