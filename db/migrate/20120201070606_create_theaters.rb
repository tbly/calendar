class CreateTheaters < ActiveRecord::Migration
  def change
    create_table :theaters do |t|
      t.references  :showtime
      t.string      :theater_name

      t.timestamps
    end

    add_index :theaters, :showtime_id
  end
end
