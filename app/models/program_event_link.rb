class ProgramEventLink < ActiveRecord::Base
  include TimeHelper

belongs_to :Program
belongs_to :Event

validates_associated :Program
validates_associated :Event

acts_as_list :scope => :program_id

end
