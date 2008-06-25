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

ActiveRecord::Schema.define(:version => 20080625172427) do

  create_table "channels", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "playlists", :force => true do |t|
    t.integer  "program_id"
    t.integer  "channel_id"
    t.datetime "start_at"
    t.boolean  "movable"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "playlists", ["start_at"], :name => "index_playlists_on_start_at"
  add_index "playlists", ["program_id", "channel_id"], :name => "index_playlists_on_program_id_and_channel_id"

  create_table "program_categories", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "default_do_vod"
    t.boolean  "default_hidden"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "program_descriptions", :force => true do |t|
    t.integer  "program_id"
    t.string   "lang"
    t.string   "title"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "program_descriptions", ["program_id"], :name => "index_program_descriptions_on_program_id"

  create_table "program_tape_links", :force => true do |t|
    t.integer  "program_id"
    t.integer  "tape_id"
    t.integer  "start_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "program_tape_links", ["program_id", "tape_id"], :name => "index_program_tape_links_on_program_id_and_tape_id"

  create_table "program_user_links", :force => true do |t|
    t.integer  "program_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "program_user_links", ["program_id", "user_id"], :name => "index_program_user_links_on_program_id_and_user_id"

  create_table "programs", :force => true do |t|
    t.integer  "program_category_id"
    t.string   "status"
    t.string   "type"
    t.text     "notes"
    t.datetime "quarantine"
    t.string   "filename"
    t.boolean  "file_exists"
    t.boolean  "file_status_updated"
    t.string   "file_aspect"
    t.integer  "file_resx"
    t.integer  "file_resy"
    t.integer  "file_length"
    t.integer  "target_length"
    t.integer  "pms_id"
    t.integer  "preview_image_offset"
    t.boolean  "do_vod"
    t.boolean  "hidden"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "programs", ["program_category_id"], :name => "index_programs_on_program_category_id"
  add_index "programs", ["do_vod"], :name => "index_programs_on_do_vod"
  add_index "programs", ["pms_id"], :name => "index_programs_on_pms_id"

  create_table "reference_logs", :force => true do |t|
    t.integer  "channel_id"
    t.integer  "tape_id"
    t.integer  "start_at"
    t.integer  "end_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reference_logs", ["channel_id", "tape_id"], :name => "index_reference_logs_on_channel_id_and_tape_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"
  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"

  create_table "tapes", :force => true do |t|
    t.string   "code"
    t.string   "title"
    t.integer  "length"
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
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

  create_table "vod_files", :force => true do |t|
    t.string   "filename"
    t.string   "full_path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vod_files", ["filename"], :name => "index_vod_files_on_filename"

  create_table "vod_formats", :force => true do |t|
    t.string   "name"
    t.string   "vcodec"
    t.string   "acodec"
    t.string   "container"
    t.integer  "vbitrate"
    t.integer  "abitrate"
    t.integer  "width"
    t.integer  "height"
    t.decimal  "framerate"
    t.string   "mime_type"
    t.string   "file_extension"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vod_formats", ["width", "height"], :name => "index_vod_formats_on_width_and_height"

  create_table "vods", :force => true do |t|
    t.string   "filename"
    t.integer  "program_id"
    t.integer  "vod_format_id"
    t.integer  "filesize"
    t.integer  "length"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vods", ["filename"], :name => "index_vods_on_filename"
  add_index "vods", ["program_id"], :name => "index_vods_on_program_id"

end
