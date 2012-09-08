class CreateShowtimes < ActiveRecord::Migration
  def change
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
