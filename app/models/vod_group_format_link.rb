class VodGroupFormatLink < ActiveRecord::Base

belongs_to :VodGroup
belongs_to :VideoFormat

validates_associated :VodGroup
validates_associated :VideoFormat

end
