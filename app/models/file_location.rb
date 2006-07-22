class FileLocation < ActiveRecord::Base

has_many :Events

def exists?(filename)
   url = URI.parse(self.checker_url)
   req = Net::HTTP::Get.new(url.path  + '?filename=' + filename)
   res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
   }
   res.body.to_s
end

end
