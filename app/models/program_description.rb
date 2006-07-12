class ProgramDescription < ActiveRecord::Base

belongs_to :Program
belongs_to :Language

validates_associated :Program
validates_associated :Language

end
