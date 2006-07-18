class ProgramDescription < ActiveRecord::Base

belongs_to :Program
belongs_to :Language

validates_associated :Program
validates_associated :Language

acts_as_list :scope => :program_id

def language
  Language.find(self.language_id)
end

end
