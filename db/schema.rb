# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090805111923) do

  create_table "channels", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "flashinfos", :force => true do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "flashinfos", ["key"], :name => "index_flashinfos_on_key"

  create_table "playlists", :force => true do |t|
    t.integer  "program_id", :limit => 11
    t.integer  "channel_id", :limit => 11
    t.datetime "start_at"
    t.boolean  "movable"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "playlists", ["program_id", "channel_id"], :name => "index_playlists_on_program_id_and_channel_id"
  add_index "playlists", ["start_at"], :name => "index_playlists_on_start_at"
  add_index "playlists", ["channel_id"], :name => "fk_playlists_channel_id"

  create_table "program_categories", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "default_do_vod"
    t.boolean  "default_hidden"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "program_descriptions", :force => true do |t|
    t.integer  "program_id",  :limit => 11
    t.string   "lang"
    t.string   "title"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "program_descriptions", ["program_id"], :name => "index_program_descriptions_on_program_id"

  create_table "programs", :force => true do |t|
    t.integer  "program_category_id",  :limit => 11
    t.integer  "program_id",           :limit => 11
    t.integer  "owner_id",             :limit => 11
    t.string   "status"
    t.string   "programtype"
    t.text     "notes"
    t.datetime "quarantine"
    t.string   "filename"
    t.boolean  "file_exists"
    t.boolean  "file_status_updated"
    t.string   "file_aspect"
    t.integer  "file_resx",            :limit => 11
    t.integer  "file_resy",            :limit => 11
    t.integer  "file_length",          :limit => 11
    t.integer  "target_length",        :limit => 11
    t.integer  "pms_id",               :limit => 11
    t.integer  "preview_image_offset", :limit => 11
    t.boolean  "do_vod"
    t.boolean  "hidden"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "programs", ["pms_id"], :name => "index_programs_on_pms_id"
  add_index "programs", ["do_vod"], :name => "index_programs_on_do_vod"
  add_index "programs", ["program_category_id"], :name => "index_programs_on_program_category_id"
  add_index "programs", ["program_id"], :name => "index_programs_on_program_id"
  add_index "programs", ["owner_id"], :name => "index_programs_on_owner_id"

  create_table "programs_programs", :force => true do |t|
    t.integer  "program_id",    :limit => 11
    t.integer  "subprogram_id", :limit => 11
    t.integer  "position",      :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "programs_programs", ["subprogram_id"], :name => "fk_programs_programs_subprogram_id"
  add_index "programs_programs", ["program_id"], :name => "index_programs_programs_on_program_id"

  create_table "programs_tapes", :force => true do |t|
    t.integer "program_id", :limit => 11
    t.integer "tape_id",    :limit => 11
    t.integer "start_at",   :limit => 11
  end

  add_index "programs_tapes", ["program_id", "tape_id"], :name => "index_programs_tapes_on_program_id_and_tape_id"
  add_index "programs_tapes", ["tape_id"], :name => "fk_programs_tapes_tape_id"

  create_table "programs_users", :force => true do |t|
    t.integer "program_id", :limit => 11
    t.integer "user_id",    :limit => 11
    t.string  "usertype"
  end

  add_index "programs_users", ["program_id", "user_id"], :name => "index_programs_users_on_program_id_and_user_id"
  add_index "programs_users", ["user_id"], :name => "fk_programs_users_user_id"

  create_table "reference_logs", :force => true do |t|
    t.integer  "channel_id", :limit => 11
    t.integer  "tape_id",    :limit => 11
    t.integer  "start_at",   :limit => 11
    t.integer  "end_at",     :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reference_logs", ["channel_id", "tape_id"], :name => "index_reference_logs_on_channel_id_and_tape_id"
  add_index "reference_logs", ["tape_id"], :name => "fk_reference_logs_tape_id"

  create_table "runlists", :force => true do |t|
    t.integer  "program_id", :limit => 11
    t.integer  "position",   :limit => 11
    t.string   "source"
    t.text     "video"
    t.text     "audio"
    t.text     "content"
    t.integer  "length",     :limit => 11
    t.text     "info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "runlists", ["program_id"], :name => "index_runlists_on_program_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "tapes", :force => true do |t|
    t.string   "code"
    t.string   "title"
    t.integer  "length",     :limit => 11
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tapes", ["type"], :name => "index_tapes_on_type"

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.integer  "level",                     :limit => 11,  :default => 0
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

  create_table "vod_formats", :force => true do |t|
    t.string   "name"
    t.string   "vcodec"
    t.string   "acodec"
    t.string   "container"
    t.integer  "vbitrate",       :limit => 11
    t.integer  "abitrate",       :limit => 11
    t.integer  "width",          :limit => 11
    t.integer  "height",         :limit => 11
    t.integer  "framerate",      :limit => 10, :precision => 10, :scale => 0
    t.string   "mime_type"
    t.string   "file_extension"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vod_formats", ["width", "height"], :name => "index_vod_formats_on_width_and_height"

  create_table "vods", :force => true do |t|
    t.string   "filename"
    t.integer  "program_id",    :limit => 11
    t.integer  "vod_format_id", :limit => 11
    t.integer  "filesize",      :limit => 11
    t.integer  "length",        :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "full_path"
  end

  add_index "vods", ["program_id"], :name => "index_vods_on_program_id"
  add_index "vods", ["filename"], :name => "index_vods_on_filename"
  add_index "vods", ["vod_format_id"], :name => "fk_vods_vod_format_id"

end
