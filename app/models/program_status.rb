class ProgramStatus < ActiveRecord::Base

has_many :Programs, :foreign_key => 'status_id'

end
