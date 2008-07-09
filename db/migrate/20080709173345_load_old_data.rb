require 'active_record/fixtures'

class LoadOldData < ActiveRecord::Migration
  def self.up
	
		dir = File.join(File.dirname(__FILE__), "data")
		Fixtures.create_fixtures dir, "channels"
		Fixtures.create_fixtures dir, "playlists"
		Fixtures.create_fixtures dir, "program_categories"
		Fixtures.create_fixtures dir, "program_descriptions"
		Fixtures.create_fixtures dir, "programs"
		Fixtures.create_fixtures dir, "programs_tapes"
		Fixtures.create_fixtures dir, "programs_users"
		Fixtures.create_fixtures dir, "tapes"
		Fixtures.create_fixtures dir, "users"
		Fixtures.create_fixtures dir, "vod_formats"
		Fixtures.create_fixtures dir, "vods"

		
  end

  def self.down
  end
end
