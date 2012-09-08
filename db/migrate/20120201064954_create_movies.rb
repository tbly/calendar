class CreateMovies < ActiveRecord::Migration
  def up
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
  end

  def down
    drop_table :movies
  end
end
