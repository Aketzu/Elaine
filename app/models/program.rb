class Program < ActiveRecord::Base
  include TimeHelper
  include ActionView::Helpers::TextHelper

belongs_to :User, :foreign_key => 'owner_id'
belongs_to :ProgramStatus, :foreign_key => 'status_id'
belongs_to :ProgramCategory
belongs_to :FileLocation
belongs_to :VideoFormat

has_many   :playlists, :dependent => :destroy

has_many   :program_descriptions, :dependent => :destroy

has_many   :tape_program_links, :dependent => :destroy
has_many   :Tapes,  :through => :tape_program_links
has_many   :program_event_links, :order => :position, :dependent => :destroy
has_many   :Events, :through => :program_event_links, :order => :position
has_many   :vods, :dependent => :destroy
# Doesn't work like this (ignores link)
#has_many   :VodFormats, :through => :ProgramCategory

validates_associated :User
validates_associated :ProgramStatus
validates_associated :ProgramCategory
validates_associated :FileLocation
validates_associated :VideoFormat
validates_presence_of(:formatted_length, :message => "can not be empty")
validates_format_of(:filename, :with => /^[a-zA-Z0-9\-\_]*$/, :message => "contains illegal characters.")

def owner
	self.User
end

def Vods
	vods
end

def quarantine
  self.Events.maximum('quarantine') || self.created_at
end

def length
	return @length if @length

	@length = 0
	self.Events.each {|e| @length += e.length }
	return @length
	#@length || @length = (self.Events.sum('length') || 0)
end

def status
  ProgramStatus.find(self.status_id).name
end

def title  # might require some tunkking yet
	@descriptor = self.program_descriptions[0]

  if (@descriptor) then
    @descriptor.title || "-"
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

# TODO: This is a legacy wrapper, any single event is now ok for filename inheritance
def single_insert?
  single_event?
end

# TODO: This has the additional requirement of an empty filename to allow old files to work
# TODO: This requirement should be removed after a data cleanup
def single_event?
  real_filename = read_attribute(:filename)
  unless(real_filename.nil? or real_filename == "")
    nil
  else
    #@single_event || @single_event = (self.Events.count == 1)
    @single_event || @single_event = (self.Events[1].nil?)
  end
end

def formatted_length
  format_length(length)
end

def formatted_length=(formatted)
  self.length = parse_formatted_length(formatted)
end

def formatted_target_length
  format_length(target_length)
end

def formatted_target_length=(formatted)
  self.target_length = parse_formatted_length(formatted)
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

def filename
	return "" if self.Events[0].nil?

  if(self.single_event?)
    self.Events[0].filename
  else
    read_attribute(:filename)
  end
end

def full_filename
	return "" if self.Events[0].nil?

  if(self.single_event?)
    self.Events[0].full_filename if self.Events[0]
  else
    'p_' + self.id.to_s + '_' + self.filename.to_s + '.avi'
  end
end

def file_exists?
  #if(self.single_event?)
  #    self.Events[0].file_exists? if self.Events[0]
  #else
  #  if(self.FileLocation)
  #    self.FileLocation.exists?(self.full_filename)
  #  else
  #    nil
  #  end
  #end
	file_exists
end

def vods_or_info_updated_at
  #value = self.Vods.maximum(:updated_at)
	value = Time.at(0)
	self.Vods.each {|v|
		value = v.updated_at if value < v.updated_at
	}

  if value == 0 || self.updated_at > value
    value = self.updated_at
  end
  value
end

protected
  def strip_fields
    [:notes].each do |field|
      self[field]=strip_tags(self[field])
    end
  end

end
