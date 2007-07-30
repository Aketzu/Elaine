class Vod < ActiveRecord::Base

belongs_to :Program
belongs_to :VideoFormat
belongs_to :FileLocation

validates_associated :Program
validates_associated :VideoFormat
validates_associated :FileLocation

validate_on_create :validates_uniqueness_of_video_format

def validates_uniqueness_of_video_format
  unless Vod.find(:first, :conditions => ['video_format_id = ? AND program_id = ? AND file_location_id = ?',
                                          self.video_format_id, self.program_id, self.file_location_id]).nil?
    errors.add_to_base("Video format not unique")
  end
end

def base_filename
  self.program_id.to_s + "_" + self.filename
end


def full_filename
  base_filename + '.' + self.VideoFormat.file_extension
end

# TODO: Maybe change so that filename does not contain bitrate etc?
def preview_base_filename
  self.Program.id.to_s + "_" + self.Program.filename   
end

def file_exists?
  #self.FileLocation.exists?(self.full_filename)
	file_exists
end

end
