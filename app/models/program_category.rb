class ProgramCategory < ActiveRecord::Base

belongs_to :VodGroup
has_many :Programs

validates_associated :VodGroup

end
