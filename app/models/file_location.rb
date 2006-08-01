class FileLocation < ActiveRecord::Base

has_many :Events
has_many :Programs

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
     nil
   end
   rescue
     nil
end

end
