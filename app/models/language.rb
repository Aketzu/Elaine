class Language < ActiveRecord::Base

has_many :ProgramDescriptions

def Language.get_compulsory
  Language.find(:all, :conditions => ["compulsory = ?", 'true'])
end

end
