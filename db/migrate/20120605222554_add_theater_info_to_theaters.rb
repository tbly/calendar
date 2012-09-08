class AddTheaterInfoToTheaters < ActiveRecord::Migration
  def change
    add_column :theaters, :theater_info, :string
  end
end
