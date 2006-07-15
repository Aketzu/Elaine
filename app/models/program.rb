class Program < ActiveRecord::Base
  include TimeHelper

belongs_to :User
belongs_to :ProgramStatus

has_many   :ProgramDescriptions

has_many   :TapeProgramLinks
has_many   :Tapes,  :through => :TapeProgramLinks
has_many   :ProgramEventLinks, :order => :position

validates_associated :User
validates_associated :ProgramStatus

def formatted_length
  format_length(length)
end

def formatted_length=(formatted)
  self.length = parse_formatted_length(formatted)
end

def formatted_preview_image_offset
  format_length(preview_image_offset)
end

def formatted_preview_image_offset=(formatted)
  self.preview_image_offset = parse_formatted_length(formatted)
end

def formatted_preview_video_offset
  format_length(preview_video_offset)
end

def formatted_preview_video_offset=(formatted)
  self.preview_video_offset = parse_formatted_length(formatted)
end

end
