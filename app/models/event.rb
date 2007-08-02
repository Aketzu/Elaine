class Event < ActiveRecord::Base
  include TimeHelper
  include ActionView::Helpers::TextHelper

belongs_to :Location
belongs_to :EventType
belongs_to :FileLocation
belongs_to :VideoFormat

has_many :tape_event_links, :dependent => :destroy
has_many :Tapes,    :through => :tape_event_links
has_many :program_event_links, :dependent => :destroy
has_many :Programs, :through => :program_event_links

before_validation :strip_fields
validates_associated :Location
validates_associated :EventType
validates_presence_of(:title, :message => "can not be empty")
validates_presence_of(:formatted_length, :message => "can not be empty")
validates_format_of(:filename, :with => /^[a-zA-Z0-9\-\_]*$/, :message => "contains illegal characters.")

def formatted_length
  format_length(length)
end

def formatted_length=(formatted)
  self.length = parse_formatted_length(formatted)
end

def full_filename
  "e_" + self.id.to_s + "_" + (self.filename || "") + "." + extension
end

def extension
	return "avi" if self.VideoFormat.nil?
	self.VideoFormat.file_extension
end

def file_exists?
  #if(self.FileLocation)
  #  self.FileLocation.exists?(self.full_filename)
  #else
  #  false
  #end
	file_exists
end

def tooltip
	title + " " + formatted_length + "<br />" + self.EventType.name + " @" + self.Location.name
end

protected
  def strip_fields
    [:title, :script, :notes].each do |field|
      self[field]=strip_tags(self[field])
    end
  end

end
