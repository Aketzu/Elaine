class Tape < ActiveRecord::Base
  include TimeHelper
  include ActionView::Helpers::TextHelper

belongs_to :User
belongs_to :TapeMedia
belongs_to :TapeCategory

has_many :tape_program_links, :dependent => :destroy
has_many :tape_event_links, :dependent => :destroy
has_many :Programs, :through => :tape_program_links
has_many :Events,   :through => :tape_event_links
has_many :ReferenceLogEntries

before_validation :strip_fields
validates_presence_of :code
validates_uniqueness_of :code
validates_presence_of :title
validates_presence_of :length
validates_associated  :User
validates_associated  :TapeMedia
validates_associated  :TapeCategory

def formatted_length
  format_length(length)
end

def formatted_length=(formatted)
  self.length = parse_formatted_length(formatted)
end

protected
  def strip_fields
    [:title, :code].each do |field|
      self[field]=strip_tags(self[field])
    end
  end

end