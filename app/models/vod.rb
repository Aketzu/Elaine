class Vod < ActiveRecord::Base

belongs_to :Program
belongs_to :VodFormat
belongs_to :FileLocation

validates_associated :Program
validates_associated :VodFormat
validates_associated :FileLocation

validate_on_create :validates_uniqueness_of_vod_format

def validates_uniqueness_of_vod_format
  unless Vod.find(:first, :conditions => ['vod_format_id = ? AND program_id = ? AND file_location_id = ?',
                                          self.vod_format_id, self.program_id, self.file_location_id]).nil?
    errors.add_to_base("Vod format not unique")
  end
end

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
