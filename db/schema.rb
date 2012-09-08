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

ActiveRecord::Schema.define(:version => 20120905022554) do

  create_table "arrests", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.datetime "date"
    t.date     "dob"
    t.integer  "age"
    t.string   "location"
    t.string   "incident"
    t.boolean  "cited",      :default => false
    t.boolean  "arrested",   :default => false
    t.text     "charges"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assignments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "assignments", ["role_id"], :name => "index_assignments_on_role_id"
  add_index "assignments", ["user_id"], :name => "index_assignments_on_user_id"

  create_table "categories", :force => true do |t|
    t.string   "category_type"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "coupon_restrictions", :force => true do |t|
    t.text     "description"
    t.integer  "limit_count"
    t.integer  "type_id"
    t.integer  "coupon_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "coupon_restrictions", ["coupon_id"], :name => "index_coupon_restrictions_on_coupon_id"

  create_table "coupons", :force => true do |t|
    t.string   "code"
    t.date     "expire_date"
    t.integer  "expire_type"
    t.integer  "event_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "coupons", ["event_id"], :name => "index_coupons_on_event_id"

  create_table "event_categories", :force => true do |t|
    t.integer  "category_id"
    t.integer  "event_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "event_categories", ["category_id"], :name => "index_event_categories_on_category_id"
  add_index "event_categories", ["event_id"], :name => "index_event_categories_on_event_id"

  create_table "event_locations", :force => true do |t|
    t.string   "venue_name"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.float    "lat"
    t.float    "lng"
    t.integer  "event_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "event_locations", ["event_id"], :name => "index_event_locations_on_event_id"

  create_table "event_timings", :force => true do |t|
    t.date     "on_date"
    t.string   "on_time"
    t.integer  "duration"
    t.integer  "event_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "event_timings", ["event_id"], :name => "index_event_timings_on_event_id"

  create_table "events", :force => true do |t|
    t.string   "type"
    t.integer  "user_id"
    t.string   "title"
    t.text     "description"
    t.string   "cost"
    t.boolean  "is_family_event", :default => false
    t.string   "business_name"
    t.string   "contact_phone"
    t.string   "contact_website"
    t.string   "contact_email"
    t.integer  "event_type"
    t.string   "status"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "events", ["type"], :name => "index_events_on_type"
  add_index "events", ["user_id"], :name => "index_events_on_user_id"

  create_table "local_news_articles", :force => true do |t|
    t.string   "title",        :null => false
    t.string   "url",          :null => false
    t.string   "author",       :null => false
    t.text     "content",      :null => false
    t.string   "guid",         :null => false
    t.datetime "published_at", :null => false
    t.string   "image_url"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "local_news_articles", ["guid"], :name => "index_local_news_articles_on_guid", :unique => true

  create_table "local_news_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "local_news_categories", ["name"], :name => "index_local_news_categories_on_name", :unique => true

  create_table "local_news_categorizations", :force => true do |t|
    t.integer  "local_news_article_id"
    t.integer  "local_news_category_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  add_index "local_news_categorizations", ["local_news_article_id"], :name => "index_local_news_categorizations_on_local_news_article_id"
  add_index "local_news_categorizations", ["local_news_category_id"], :name => "index_local_news_categorizations_on_local_news_category_id"

  create_table "local_news_listings", :force => true do |t|
    t.integer  "local_news_article_id"
    t.integer  "local_news_source_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  add_index "local_news_listings", ["local_news_article_id"], :name => "index_local_news_listings_on_local_news_article_id"
  add_index "local_news_listings", ["local_news_source_id"], :name => "index_local_news_listings_on_local_news_source_id"

  create_table "local_news_sources", :force => true do |t|
    t.string   "title",      :null => false
    t.string   "url",        :null => false
    t.string   "feed_url",   :null => false
    t.string   "etag",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "local_news_sources", ["feed_url"], :name => "index_local_news_sources_on_feed_url", :unique => true

  create_table "movies", :force => true do |t|
    t.integer  "cs_id",               :null => false
    t.string   "title",               :null => false
    t.text     "photos"
    t.text     "high_quality_photos"
    t.string   "rating"
    t.text     "advisory"
    t.text     "genres"
    t.text     "cast"
    t.text     "directors"
    t.text     "release_dates"
    t.integer  "running_time"
    t.text     "official_site"
    t.string   "distributor"
    t.text     "producers"
    t.text     "writers"
    t.text     "summary"
    t.string   "stars"
    t.text     "review"
    t.text     "attribute_history"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "movies", ["cs_id"], :name => "index_movies_on_cs_id"
  add_index "movies", ["title"], :name => "index_movies_on_title"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "settings", :force => true do |t|
    t.string   "var",                      :null => false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", :limit => 30
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "settings", ["thing_type", "thing_id", "var"], :name => "index_settings_on_thing_type_and_thing_id_and_var", :unique => true

  create_table "showtimes", :force => true do |t|
    t.integer  "movie_id"
    t.integer  "theater_id"
    t.datetime "playing_at",                             :null => false
    t.date     "playing_on",                             :null => false
    t.text     "link",                                   :null => false
    t.boolean  "bargain",             :default => false, :null => false
    t.string   "showtime_attributes"
    t.boolean  "passes",              :default => false, :null => false
    t.boolean  "festival",            :default => false, :null => false
    t.string   "show_with"
    t.string   "sound"
    t.text     "comments"
    t.text     "attribute_history"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "showtimes", ["movie_id"], :name => "index_showtimes_on_movie_id"
  add_index "showtimes", ["playing_on"], :name => "index_showtimes_on_playing_on"
  add_index "showtimes", ["theater_id"], :name => "index_showtimes_on_theater_id"

  create_table "theaters", :force => true do |t|
    t.integer  "cs_id",                                  :null => false
    t.string   "name",                                   :null => false
    t.string   "address",                                :null => false
    t.string   "city",                                   :null => false
    t.string   "state",                                  :null => false
    t.string   "zip",                                    :null => false
    t.string   "phone",                                  :null => false
    t.string   "theater_attributes"
    t.string   "county",                                 :null => false
    t.boolean  "ticketing",           :default => false, :null => false
    t.string   "closed_reason"
    t.string   "area"
    t.string   "location"
    t.string   "market"
    t.integer  "screens"
    t.string   "seating"
    t.string   "adult_price"
    t.string   "child_price"
    t.string   "senior_price"
    t.string   "adult_bargain_price"
    t.string   "price_comment"
    t.string   "sound"
    t.string   "latitude"
    t.string   "longitude"
    t.text     "attribute_history"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "theaters", ["cs_id"], :name => "index_theaters_on_cs_id"
  add_index "theaters", ["name"], :name => "index_theaters_on_name"

  create_table "users", :force => true do |t|
    t.string   "username",                                       :null => false
    t.string   "email"
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.string   "activation_state"
    t.string   "activation_token"
    t.datetime "activation_token_expires_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.integer  "failed_logins_count",             :default => 0
    t.datetime "lock_expires_at"
    t.string   "name"
    t.string   "phone"
  end

  add_index "users", ["activation_token"], :name => "index_users_on_activation_token"
  add_index "users", ["remember_me_token"], :name => "index_users_on_remember_me_token"

end
