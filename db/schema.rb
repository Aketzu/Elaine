# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 51) do

  create_table "broadcast_logs", :force => true do |t|
    t.column "start_time", :datetime
    t.column "program_id", :integer
    t.column "channel_id", :integer,  :default => 1
  end

  create_table "channels", :force => true do |t|
    t.column "name",        :string
    t.column "description", :text
  end

  create_table "engine_schema_info", :id => false, :force => true do |t|
    t.column "engine_name", :string
    t.column "version",     :integer
  end

  create_table "event_types", :force => true do |t|
    t.column "name",        :string
    t.column "description", :text
  end

  create_table "events", :force => true do |t|
    t.column "title",            :string
    t.column "script",           :text
    t.column "location_id",      :integer,  :default => 1
    t.column "event_type_id",    :integer
    t.column "notes",            :text
    t.column "length",           :integer
    t.column "quarantine",       :datetime
    t.column "created_at",       :datetime
    t.column "updated_at",       :datetime
    t.column "filename",         :string
    t.column "file_location_id", :integer
  end

  create_table "file_locations", :force => true do |t|
    t.column "name",        :string
    t.column "description", :text
    t.column "url",         :string
    t.column "checker_url", :string
  end

  create_table "languages", :force => true do |t|
    t.column "name",       :string
    t.column "code",       :string
    t.column "compulsory", :boolean, :default => true
  end

  create_table "locations", :force => true do |t|
    t.column "name",        :string
    t.column "description", :text
  end

  create_table "people", :force => true do |t|
    t.column "name",         :string
    t.column "title",        :string
    t.column "organization", :string
    t.column "phone",        :string
    t.column "email",        :string
  end

  create_table "permissions", :force => true do |t|
    t.column "controller",  :string, :default => "", :null => false
    t.column "action",      :string, :default => "", :null => false
    t.column "description", :string
  end

  create_table "permissions_roles", :id => false, :force => true do |t|
    t.column "permission_id", :integer, :default => 0, :null => false
    t.column "role_id",       :integer, :default => 0, :null => false
  end

  create_table "playlists", :force => true do |t|
    t.column "start_time", :datetime
    t.column "movable",    :boolean
    t.column "program_id", :integer
    t.column "channel_id", :integer,  :default => 1
  end

  create_table "program_descriptions", :force => true do |t|
    t.column "private_description", :text
    t.column "public_description",  :text
    t.column "title",               :string
    t.column "program_id",          :integer
    t.column "language_id",         :integer, :default => 1
    t.column "position",            :integer
  end

  create_table "program_event_links", :force => true do |t|
    t.column "position",   :integer
    t.column "program_id", :integer
    t.column "event_id",   :integer
  end

  create_table "program_statuses", :force => true do |t|
    t.column "name",        :string
    t.column "description", :text
  end

  create_table "programs", :force => true do |t|
    t.column "notes",                :text
    t.column "min_show",             :integer
    t.column "max_show",             :integer
    t.column "do_vod",               :boolean
    t.column "created_at",           :datetime
    t.column "updated_at",           :datetime
    t.column "preview_image_offset", :integer
    t.column "preview_video_offset", :integer
    t.column "owner_id",             :integer
    t.column "status_id",            :integer,  :default => 1
    t.column "filename",             :string
    t.column "file_location_id",     :integer
    t.column "vod_group_id",         :integer
  end

  create_table "reference_log_entries", :force => true do |t|
    t.column "tape_id",    :integer
    t.column "start_time", :datetime
    t.column "end_time",   :datetime
    t.column "channel_id", :integer
  end

  create_table "roles", :force => true do |t|
    t.column "name",        :string,  :default => "",    :null => false
    t.column "description", :string
    t.column "omnipotent",  :boolean, :default => false, :null => false
    t.column "system_role", :boolean, :default => false, :null => false
  end

  create_table "sessions", :force => true do |t|
    t.column "session_id", :string
    t.column "data",       :text
    t.column "updated_at", :datetime
  end

  add_index "sessions", ["session_id"], :name => "sessions_session_id_index"

  create_table "tape_categories", :force => true do |t|
    t.column "name",        :string
    t.column "description", :text
  end

  create_table "tape_event_links", :force => true do |t|
    t.column "start_time", :integer
    t.column "tape_id",    :integer
    t.column "event_id",   :integer
  end

  create_table "tape_medias", :force => true do |t|
    t.column "name",        :string
    t.column "description", :text
  end

  create_table "tape_program_links", :force => true do |t|
    t.column "start_time", :integer
    t.column "tape_id",    :integer
    t.column "program_id", :integer
  end

  create_table "tapes", :force => true do |t|
    t.column "code",        :string
    t.column "title",       :text
    t.column "length",      :integer
    t.column "owner_id",    :integer
    t.column "media_id",    :integer, :default => 2
    t.column "category_id", :integer, :default => 1
  end

  create_table "users", :force => true do |t|
    t.column "login",                     :string,   :limit => 80, :default => "", :null => false
    t.column "crypted_password",          :string,   :limit => 40, :default => "", :null => false
    t.column "email",                     :string,   :limit => 60, :default => "", :null => false
    t.column "firstname",                 :string,   :limit => 40
    t.column "lastname",                  :string,   :limit => 40
    t.column "salt",                      :string,   :limit => 40, :default => "", :null => false
    t.column "verified",                  :integer,                :default => 0
    t.column "created_at",                :datetime
    t.column "updated_at",                :datetime
    t.column "remember_token",            :string
    t.column "remember_token_expires_at", :datetime
  end

  create_table "users_roles", :id => false, :force => true do |t|
    t.column "user_id", :integer, :default => 0, :null => false
    t.column "role_id", :integer, :default => 0, :null => false
  end

  create_table "vod_formats", :force => true do |t|
    t.column "name",        :string
    t.column "description", :text
    t.column "vcodec",      :string
    t.column "acodec",      :string
    t.column "container",   :string
    t.column "vbitrate",    :integer
    t.column "abitrate",    :integer
    t.column "width",       :integer
    t.column "height",      :integer
    t.column "framerate",   :integer
  end

  create_table "vod_group_format_links", :force => true do |t|
    t.column "vod_group_id",  :integer
    t.column "vod_format_id", :integer
  end

  create_table "vod_groups", :force => true do |t|
    t.column "name",        :string
    t.column "description", :text
  end

  create_table "vods", :force => true do |t|
    t.column "filename",         :string
    t.column "file_location_id", :integer
    t.column "length",           :integer
    t.column "filesize",         :integer
    t.column "vod_format_id",    :integer
    t.column "completed",        :boolean
    t.column "created_at",       :datetime
    t.column "updated_at",       :datetime
    t.column "program_id",       :integer
  end

end
