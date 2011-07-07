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

ActiveRecord::Schema.define(:version => 20110705150856) do

  create_table "activity_logs", :force => true do |t|
    t.integer  "event_code"
    t.integer  "primary_id"
    t.string   "primary_type"
    t.integer  "action_object_id"
    t.string   "action_object_type"
    t.string   "action_object_type_readable"
    t.integer  "secondary_id"
    t.string   "secondary_type"
    t.string   "secondary_short_name"
    t.string   "secondary_full_name"
    t.integer  "related_id"
    t.string   "related_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_type_id"
  end

  add_index "activity_logs", ["event_code"], :name => "index_activity_logs_on_event_code"
  add_index "activity_logs", ["primary_id", "primary_type"], :name => "index_activity_logs_on_primary_id_and_primary_type"

  create_table "comments", :force => true do |t|
    t.string   "title",            :limit => 50, :default => ""
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "entities", :force => true do |t|
    t.integer  "entity_type_id"
    t.integer  "specific_entity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entity_types", :force => true do |t|
    t.string   "entity_type_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_displays", :force => true do |t|
    t.integer  "type_id"
    t.integer  "person_id"
    t.integer  "event_log_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_entities", :force => true do |t|
    t.integer  "event_log_id"
    t.integer  "entity_id"
    t.string   "entity_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "user_only",    :default => false
  end

  add_index "event_entities", ["entity_id", "entity_type"], :name => "index_event_entities_on_entity_id_and_entity_type"
  add_index "event_entities", ["event_log_id"], :name => "index_event_entities_on_event_log_id"

  create_table "event_logs", :force => true do |t|
    t.integer  "primary_id"
    t.string   "primary_type"
    t.string   "primary_short_name"
    t.string   "primary_full_name"
    t.integer  "action_object_id"
    t.string   "action_object_type"
    t.string   "action_object_type_readable"
    t.integer  "secondary_id"
    t.string   "secondary_type"
    t.string   "secondary_short_name"
    t.string   "secondary_full_name"
    t.integer  "related_id"
    t.string   "related_type"
    t.integer  "event_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_types", :force => true do |t|
    t.string   "name"
    t.integer  "group"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feedbacks", :force => true do |t|
    t.integer  "item_request_id"
    t.integer  "person_id"
    t.integer  "feedback",        :limit => 255
    t.string   "feedback_note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", :force => true do |t|
    t.integer  "inviter_person_id"
    t.integer  "invitation_unique_key"
    t.boolean  "invitation_active"
    t.date     "accepted_date"
    t.integer  "invitee_person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_requests", :force => true do |t|
    t.integer  "requester_id"
    t.string   "requester_type"
    t.integer  "gifter_id"
    t.string   "gifter_type"
    t.integer  "item_id"
    t.text     "description"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.string   "item_type"
    t.string   "name"
    t.text     "description"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "deleted_at"
    t.integer  "status"
    t.integer  "purpose"
    t.boolean  "available"
  end

  create_table "people", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.boolean  "authorised_account", :default => false
    t.boolean  "accepted_tc_and_pp", :default => false
    t.decimal  "tc_version",         :default => 1.0
    t.decimal  "pp_version",         :default => 1.0
  end

  create_table "people_network_requests", :force => true do |t|
    t.integer  "person_id"
    t.integer  "trusted_person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people_networks", :force => true do |t|
    t.integer  "person_id"
    t.integer  "trusted_person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "entity_id"
    t.integer  "entity_type_id"
  end

  create_table "person_gift_act_ratings", :force => true do |t|
    t.integer  "person_id"
    t.float    "gift_act_rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reputation_ratings", :force => true do |t|
    t.integer  "person_id"
    t.integer  "gift_actions"
    t.integer  "distinct_people"
    t.integer  "total_actions"
    t.integer  "positive_feedback"
    t.integer  "negative_feedback"
    t.integer  "requests_received"
    t.integer  "requests_answered"
    t.integer  "trusted_network_count"
    t.integer  "activity_level"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "neutral_feedback",      :default => 0
  end

  create_table "requested_invitations", :force => true do |t|
    t.integer  "user_id"
    t.date     "invitation_sent_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resource_networks", :force => true do |t|
    t.integer  "entity_id"
    t.integer  "entity_type_id"
    t.integer  "resource_id"
    t.integer  "resource_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "nickname"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
  end

end
