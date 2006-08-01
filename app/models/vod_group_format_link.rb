class VodGroupFormatLink < ActiveRecord::Base

belongs_to :VodGroup
belongs_to :VodFormat

validates_associated :VodGroup
validates_associated :FodFormat

end
