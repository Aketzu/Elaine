class Vod < ActiveRecord::Base

belongs_to :Program
belongs_to :VodFormat

validates_associated :Program
validates_associated :VodFormat

def base_filename
  self.id.to_s + "_" + self.filename
end


def full_filename
  self.id.to_s + "_" + self.filename + ".avi"
end

def file_exists?
  self.FileLocation.exists?(self.full_filename)
end

end
