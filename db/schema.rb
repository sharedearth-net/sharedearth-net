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

ActiveRecord::Schema.define(:version => 20111028122306) do

  create_table "active_admin_comments", :force => true do |t|
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

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
    t.boolean  "read",                        :default => false
    t.integer  "email_notification_id"
  end

  add_index "activity_logs", ["event_code"], :name => "index_activity_logs_on_event_code"
  add_index "activity_logs", ["primary_id", "primary_type"], :name => "index_activity_logs_on_primary_id_and_primary_type"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

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

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "email_notifications", :force => true do |t|
    t.integer  "person_id"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.text     "feedback_note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "feedback"
  end

  create_table "invitations", :force => true do |t|
    t.integer  "inviter_person_id"
    t.integer  "invitation_unique_key"
    t.boolean  "invitation_active"
    t.date     "accepted_date"
    t.integer  "invitee_person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "invitee_email"
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
    t.boolean  "deleted",            :default => false
  end

  create_table "people", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.boolean  "authorised_account",       :default => false
    t.boolean  "accepted_tc",              :default => false
    t.decimal  "tc_version",               :default => 1.0
    t.decimal  "pp_version",               :default => 1.0
    t.string   "location"
    t.text     "description"
    t.boolean  "accepted_pp",              :default => false
    t.string   "email"
    t.boolean  "accepted_tr",              :default => false
    t.boolean  "has_reviewed_profile",     :default => false
    t.integer  "invitations_count"
    t.integer  "email_notification_count", :default => 0
    t.datetime "last_notification_email"
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
    t.boolean  "sent"
    t.boolean  "accepted"
  end

  create_table "resource_networks", :force => true do |t|
    t.integer  "entity_id"
    t.integer  "entity_type_id"
    t.integer  "resource_id"
    t.integer  "resource_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", :force => true do |t|
    t.string   "var",                      :null => false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", :limit => 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["thing_type", "thing_id", "var"], :name => "index_settings_on_thing_type_and_thing_id_and_var", :unique => true

  create_table "users", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
    t.datetime "lockout"
    t.integer  "validations_failed", :default => 0
    t.datetime "last_activity"
  end

end
