class AddDefaultChannels < ActiveRecord::Migration
  def self.up
		Channel.new(:name => "AssemblyTV").save!
		Channel.new(:name => "Seminars").save!
  end

  def self.down
		Channel.delete(Channel.find_by_name("AssemblyTV").id)
		Channel.delete(Channel.find_by_name("Seminars").id)
  end
end
