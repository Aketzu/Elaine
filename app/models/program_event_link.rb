class ProgramEventLink < ActiveRecord::Base
  include TimeHelper

belongs_to :Program
belongs_to :Event

validates_associated :Program
validates_associated :Event

#Allow same event only once in a program
validates_uniqueness_of :event_id, :scope => :program_id

acts_as_list :scope => :program_id

end
