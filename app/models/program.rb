class Program < ActiveRecord::Base
  include TimeHelper

belongs_to :User
belongs_to :ProgramStatus
has_many   :Playlist

has_many   :ProgramDescriptions

has_many   :tape_program_links, :dependent => :destroy
has_many   :Tapes,  :through => :tape_program_links
has_many   :program_event_links, :order => :position, :dependent => :destroy
has_many   :Events, :through => :program_event_links

validates_associated :User
validates_associated :ProgramStatus

def quarantine
  self.Events.maximum('quarantine') || self.created
end

def length
  self.Events.sum('length') || 0 
end

def title  # might require some tunkking yet
  @descriptor = self.ProgramDescriptions.find(:first)
  if (@descriptor) then
    @descriptor.title || "-"
  end
end

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
