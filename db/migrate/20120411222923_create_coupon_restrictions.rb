class CreateCouponRestrictions < ActiveRecord::Migration
  def change
    create_table :coupon_restrictions do |t|      
      t.text      :description
      t.integer   :limit_count   
      t.integer   :type_id
      t.integer   :coupon_id
      
      t.timestamps
    end
    add_index :coupon_restrictions, :coupon_id
  end
end