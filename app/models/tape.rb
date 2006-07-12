class Tape < ActiveRecord::Base

belongs_to :User
belongs_to :TapeMedia
belongs_to :TapeCategory

has_many :TapeProgramLinks
has_many :TapeEventLinks
has_many :Programs, :through => :TapeProgramLinks
has_many :Events,   :through => :TapeEventLinks

validates_presence_of :title
validates_associated  :User
validates_associated  :TapeMedia
validates_associated  :TapeCategory

end
