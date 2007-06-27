class ModifyUsersPrefs < ActiveRecord::Migration
  def self.up
    add_column :users, :content_filter_date, :date, :default => "2007-05-31"
    add_column :users, :language, :string
		
		chan = Channel.find_by_name("AssemblyTV 2007")
		unless chan 
			asm07 = Channel.new
			asm07.name="AssemblyTV 2007"
			asm07.description = asm07.name
			asm07.save!
			chan = asm07
		end

		

    add_column :users, :channel_id, :string, :default => chan.id
    # For existing users we use the following code to set default values
    users = User.find_all
    for u in users
      u.content_filter_date = "2007-05-31"
      u.channel_id = Channel.find(:first, :conditions => [ "name = ?",'AssemblyTV 2007' ]).id
      u.save
    end
  end

  def self.down
    remove_column :users, :content_filter_date
    remove_column :users, :language
    remove_column :users, :channel_id
  end
end
