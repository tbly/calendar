class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string    :code
      t.date      :expire_date
      t.integer   :expire_type   
      t.integer   :event_id
      
      t.timestamps
    end
    add_index :coupons, :event_id
  end
end