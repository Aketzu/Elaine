class Program < ActiveRecord::Base
  include TimeHelper
  include ActionView::Helpers::TextHelper

belongs_to :User
belongs_to :ProgramStatus
belongs_to :VodGroup
belongs_to :FileLocation

has_many   :playlists, :dependent => :destroy

has_many   :program_descriptions, :dependent => :destroy

has_many   :tape_program_links, :dependent => :destroy
has_many   :Tapes,  :through => :tape_program_links
has_many   :program_event_links, :order => :position, :dependent => :destroy
has_many   :Events, :through => :program_event_links

validates_associated :User
validates_associated :ProgramStatus
validates_associated :VodGroup
validates_associated :FileLocation
validates_presence_of(:formatted_length, :message => "can not be empty")
validates_format_of(:filename, :with => /^[a-zA-Z0-9\-\_]*$/, :message => "contains illegal characters.")

def quarantine
  self.Events.maximum('quarantine') || self.created_at
end

def length
  self.Events.sum('length') || 0
end

def status
  ProgramStatus.find(self.status_id).name
end

def title  # might require some tunkking yet
  @descriptor = self.program_descriptions.find(:first)
  if (@descriptor) then
    encode_entities(@descriptor.title) || "-"
  end
end

def contains_live?
  typeid = EventType.find(:first, :conditions => ["name = ?", "live"]).id
  if(self.Events.count(:conditions => ["event_type_id = ?", typeid]) > 0)
    true
  else 
    false
  end  
end

def contains_insert?
  typeid = EventType.find(:first, :conditions => ["name = ?", "insert"]).id
  if(self.Events.count(:conditions => ["event_type_id = ?", typeid]) > 0)
    true
  else 
    false
  end
end

def source?
  if(self.Tapes.size > 0)
    "Tape"
  else
    live = contains_live?
    insert = contains_insert?
    if(live and insert)
      "Live and insert"
    elsif(live)
      "Live"
    elsif(insert)
      "Insert"
    else
      "Empty!"
    end
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

def full_filename
  "p_" + self.id.to_s + "_" + (self.filename || "") + ".avi"
end

def file_exists?
  if(self.FileLocation)
    self.FileLocation.exists?(self.full_filename)
  else
    nil
  end
end

protected
  def strip_fields
    [:notes].each do |field|
      self[field]=strip_tags(self[field])
    end
  end

end
