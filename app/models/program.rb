class Program < ActiveRecord::Base

belongs_to :User
belongs_to :ProgramStatus

has_many   :ProgramDescriptions

has_many   :TapeProgramLinks
has_many   :Tapes, :through => :TapeProgramLinks

validates_associated :User
validates_associated :ProgramStatus

end
