class BroadcastLog < ActiveRecord::Base
  include TimeHelper

belongs_to :Program
belongs_to :Channel

validates_associated :Program
validates_associated :Channel

  def end_time
    start_time + self.Program.length
  end

end
