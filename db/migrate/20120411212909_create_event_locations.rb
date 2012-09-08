class CreateEventLocations < ActiveRecord::Migration
  def change
    create_table :event_locations do |t|
      t.string    :venue_name
      t.string    :street
      t.string    :city
      t.string    :street
      t.string    :state
      t.string    :zip
      t.float     :lat      
      t.float     :lng      
      t.integer   :event_id
      
      t.timestamps
    end
    add_index :event_locations, :event_id
  end
end