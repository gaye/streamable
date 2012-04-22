# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120422014950) do

  create_table "streams", :force => true do |t|
    t.integer  "publisher_id"
    t.string   "title"
    t.text     "description"
    t.datetime "when"
    t.float    "price"
    t.string   "video_preview_file_name"
    t.string   "video_preview_content_type"
    t.integer  "video_preview_file_size"
    t.datetime "video_preview_updated_at"
    t.text     "opentok_session_id"
    t.text     "publisher_token"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "streams", ["publisher_id"], :name => "index_streams_on_publisher_id"

  create_table "subscriptions", :force => true do |t|
    t.integer  "subscriber_id"
    t.integer  "stream_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.integer  "facebook_uid"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "image_url"
    t.string   "token"
    t.integer  "token_expiration"
    t.text     "raw"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "users", ["facebook_uid"], :name => "index_users_on_facebook_uid"

end
