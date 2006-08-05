class Vod < ActiveRecord::Base

belongs_to :Program
belongs_to :VodFormat
belongs_to :FileLocation

validates_associated :Program
validates_associated :VodFormat
validates_associated :FileLocation

validates_uniqueness_of :vod_format_id, :scope => [:program_id, :file_location_id]

def base_filename
  self.Program.id.to_s + "_" + self.filename
end


def full_filename
  base_filename + ".avi"
end

def file_exists?
  self.FileLocation.exists?(self.full_filename)
end

end
