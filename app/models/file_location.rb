class FileLocation < ActiveRecord::Base

has_many :Events
has_many :Programs
has_many :Vods

def exists?(filename)
   url = URI.parse(self.checker_url)
   req = Net::HTTP::Get.new(url.path  + '?filename=' + filename)
   res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
   }
   result = res.body.to_s
   if(result == "true")
     true
   else
     niltest
   end
   rescue
     nil
end

def works?
  if(self.exists?("test") and !self.exists?(" "))
    true
  else
    nil
  end
end

end
