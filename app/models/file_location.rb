class FileLocation < ActiveRecord::Base

has_many :Events
has_many :Programs
has_many :Vods

def exists?(filename)
   url = URI.parse(self.checker_url)
   logger.info url

   req = Net::HTTP::Get.new(url.path  + '?filename=' + filename)
   logger.info req

   res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
   }
   result = res.body.to_s
   logger.info result

  begin
    if(result == "true")
      true
    else
      false
    end
  rescue
    false
  end
end

def works?
  if(self.exists?("test") and !self.exists?(" "))
    true
  else
    nil
  end
end

end
