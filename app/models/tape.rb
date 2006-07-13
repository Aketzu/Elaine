class Tape < ActiveRecord::Base
  include TimeHelper

belongs_to :User
belongs_to :TapeMedia
belongs_to :TapeCategory

has_many :TapeProgramLinks
has_many :TapeEventLinks
has_many :Programs, :through => :TapeProgramLinks
has_many :Events,   :through => :TapeEventLinks

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

end