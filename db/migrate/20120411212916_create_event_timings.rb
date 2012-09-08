class CreateEventTimings < ActiveRecord::Migration
  def change
    create_table :event_timings do |t|
      t.date      :on_date
      t.string    :on_time
      t.integer   :duration      
      t.integer   :event_id
      
      t.timestamps
    end
    add_index :event_timings, :event_id
  end
end