class Playlist < ActiveRecord::Base

belongs_to :Program
belongs_to :Channel

validates_associated :Program
validates_associated :Channel

def end_time
  self.start_time + self.Program.length
end

def formatted_length
  self.Program.formatted_length
end

def channel
  Channel.find(self.channel_id)
end

def color
  if (self.Program.status == "Production")
    "green"
  else
    "red"
  end
end

end
