class UpdateMovieRelatedTables < ActiveRecord::Migration
  def up
    drop_table :movies
    drop_table :showtimes
    drop_table :theaters

    create_table :movies do |t|
      t.integer :cs_id,               :null => false
      t.string  :title,               :null => false

      t.text    :photos,              :null => true
      t.text    :high_quality_photos, :null => true
      t.string  :rating,              :null => true
      t.text    :advisory,            :null => true
      t.text    :genres,              :null => true
      t.text    :cast,                :null => true
      t.text    :directors,           :null => true
      t.text    :release_dates,       :null => true
      t.integer :running_time,        :null => true
      t.text    :official_site,       :null => true
      t.string  :distributor,         :null => true
      t.text    :producers,           :null => true
      t.text    :writers,             :null => true
      t.text    :summary,             :null => true
      t.string  :stars,               :null => true
      t.text    :review,              :null => true

      t.text    :attribute_history,   :null => true

      t.timestamps
    end

    add_index :movies, :cs_id
    add_index :movies, :title

    create_table :theaters do |t|
      t.integer :cs_id,               :null => false
      t.string  :name,                :null => false

      t.string  :address,             :null => false
      t.string  :city,                :null => false
      t.string  :state,               :null => false
      t.string  :zip,                 :null => false
      t.string  :phone,               :null => false
      t.string  :theater_attributes,  :null => true
      t.string  :county,              :null => false
      t.boolean :ticketing,           :null => false, :default => false
      t.string  :closed_reason,       :null => true
      t.string  :area,                :null => true
      t.string  :location,            :null => true
      t.string  :market,              :null => true
      t.integer :screens,             :null => true
      t.string  :seating,             :null => true
      t.string  :adult_price,         :null => true
      t.string  :child_price,         :null => true
      t.string  :senior_price,        :null => true
      t.string  :adult_bargain_price, :null => true
      t.string  :price_comment,       :null => true
      t.string  :sound,               :null => true
      t.string  :latitude,            :null => true
      t.string  :longitude,           :null => true

      t.text    :attribute_history,   :null => true

      t.timestamps
    end

    add_index :theaters, :cs_id
    add_index :theaters, :name

    create_table :showtimes do |t|
      t.references :movie
      t.references :theater

      t.datetime   :playing_at,          :null => false
      t.date       :playing_on,          :null => false

      t.text       :link,                :null => false
      t.boolean    :bargain,             :null => false, :default => false

      t.string     :showtime_attributes, :null => true
      t.boolean    :passes,              :null => false, :default => false
      t.boolean    :festival,            :null => false, :default => false
      t.string     :show_with,           :null => true
      t.string     :sound,               :null => true
      t.text       :comments,            :null => true

      t.text       :attribute_history,   :null => true

      t.timestamps
    end

    add_index :showtimes, :movie_id
    add_index :showtimes, :theater_id
    add_index :showtimes, :playing_on
  end

  def down
    drop_table :movies
    drop_table :showtimes
    drop_table :theaters

    create_table( :movies, :id => false ) do |t|
      t.integer  :id, :null => false

      t.string   :title, :default => nil, :null => true
      t.text     :genre, :null => false
      t.string   :rating, :default => nil, :null => true
      t.text     :advisory, :null => false
      t.string   :director, :default => nil, :null => true
      t.text     :summary, :null => false
      t.text     :review, :null => false
      t.text     :starring, :null => false
      t.string   :runtime, :default => nil, :null => true
      t.string   :url, :default => nil, :null => true
      t.date     :release_date, :default => nil, :null => true
      t.string   :release_type, :default => nil, :null => true
      t.string   :photo1, :default => nil, :null => true
      t.string   :photo2, :default => nil, :null => true
      t.string   :photo3, :default => nil, :null => true
      t.string   :photo4, :default => nil, :null => true
      t.string   :stars, :default => nil, :null => true
      t.string   :tmeter, :default => nil, :null => true

      t.timestamps
    end

    execute 'ALTER TABLE movies ADD PRIMARY KEY( id );'

    create_table :theaters do |t|
      t.references  :showtime
      t.string      :theater_name

      t.timestamps
    end

    add_index :theaters, :showtime_id

    create_table :showtimes do |t|
      t.references :movie
      t.references :theater
      t.datetime   :show_date
      t.text       :showtimes

      t.timestamps
    end

    add_index :showtimes, :movie_id
    add_index :showtimes, :theater_id
  end
end
