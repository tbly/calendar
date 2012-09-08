class CreateArrests < ActiveRecord::Migration
  def up
    create_table :arrests do |t|
      t.column :name, :string
      t.column :address, :string
      t.column :date, :datetime
      t.column :dob, :date
      t.column :age, :integer
      t.column :officer, :string
      t.column :location, :string
      t.column :incident, :string
      t.column :cited, :boolean, :default => false
      t.column :arrested, :boolean, :default => false
      t.column :charges, :text

      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
    end
  end

  def down
    drop_table :arrests
  end
end
