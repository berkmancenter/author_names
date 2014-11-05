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

ActiveRecord::Schema.define(:version => 20141105194226) do

  create_table "authors", :force => true do |t|
    t.string   "phone",                       :null => false
    t.string   "email",                       :null => false
    t.string   "first_name",                  :null => false
    t.string   "last_name",                   :null => false
    t.string   "address_1",    :limit => 150, :null => false
    t.string   "address_2",    :limit => 150
    t.string   "city",         :limit => 100, :null => false
    t.string   "state",        :limit => 100, :null => false
    t.string   "postal_code",  :limit => 30,  :null => false
    t.string   "country",                     :null => false
    t.integer  "publisher_id"
    t.integer  "user_id"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "emails", :force => true do |t|
    t.string   "to"
    t.text     "bcc"
    t.string   "from"
    t.string   "reply_to"
    t.string   "subject"
    t.text     "body"
    t.date     "date_sent"
    t.boolean  "message_sent", :default => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "form_item_groups", :force => true do |t|
    t.string   "name"
    t.integer  "publisher_id"
    t.integer  "questionnaire_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "form_item_groups_questionnaires", :force => true do |t|
    t.integer "form_item_group_id"
    t.integer "questionnaire_id"
  end

  create_table "form_items", :force => true do |t|
    t.string   "field_name",                            :null => false
    t.text     "display_text"
    t.string   "field_type",                            :null => false
    t.string   "field_options"
    t.boolean  "required",           :default => false
    t.integer  "publisher_id"
    t.integer  "form_item_group_id"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  add_index "form_items", ["display_text"], :name => "index_form_items_on_display_text"
  add_index "form_items", ["field_name"], :name => "index_form_items_on_field_name"
  add_index "form_items", ["field_options"], :name => "index_form_items_on_field_options"
  add_index "form_items", ["field_type"], :name => "index_form_items_on_field_type"

  create_table "form_items_questionnaires", :force => true do |t|
    t.integer "form_item_id"
    t.integer "questionnaire_id"
    t.integer "position",         :default => 0, :null => false
  end

  create_table "libraries", :force => true do |t|
    t.string   "name",                        :null => false
    t.text     "description"
    t.string   "contact_name",                :null => false
    t.string   "phone",                       :null => false
    t.string   "email",                       :null => false
    t.string   "address_1",    :limit => 150, :null => false
    t.string   "address_2",    :limit => 150
    t.string   "city",         :limit => 100, :null => false
    t.string   "state",        :limit => 100, :null => false
    t.string   "postal_code",  :limit => 30,  :null => false
    t.string   "country",                     :null => false
    t.string   "website"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "publications", :force => true do |t|
    t.integer  "user_id"
    t.integer  "author_id"
    t.integer  "publisher_id"
    t.integer  "questionnaire_id"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.boolean  "lib_exported_flag", :default => false
    t.boolean  "pub_exported_flag", :default => false
  end

  create_table "publishers", :force => true do |t|
    t.string   "name",                        :null => false
    t.text     "description"
    t.string   "contact_name",                :null => false
    t.string   "phone",                       :null => false
    t.string   "email",                       :null => false
    t.string   "address_1",    :limit => 150, :null => false
    t.string   "address_2",    :limit => 150
    t.string   "city",         :limit => 100, :null => false
    t.string   "state",        :limit => 100, :null => false
    t.string   "postal_code",  :limit => 30,  :null => false
    t.string   "country",                     :null => false
    t.string   "website"
    t.string   "logo"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "questionnaires", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "version"
    t.integer  "publisher_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "responses", :force => true do |t|
    t.integer  "questionnaire_id",                     :null => false
    t.integer  "user_id",                              :null => false
    t.integer  "form_item_id",                         :null => false
    t.text     "response_text"
    t.boolean  "lib_exported_flag", :default => false
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.boolean  "pub_exported_flag", :default => false
    t.integer  "publication_id"
    t.string   "author_upload"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "admin",                  :default => false
    t.boolean  "staff",                  :default => false
    t.boolean  "superadmin",             :default => false
    t.boolean  "author",                 :default => false
    t.integer  "library_id"
    t.integer  "publisher_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username",               :default => "",    :null => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
