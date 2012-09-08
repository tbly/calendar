# t.text      :description
# t.integer   :limit_count   
# t.integer   :type_id
# t.integer   :coupon_id
# t.timestamps
      
class CouponRestriction < ActiveRecord::Base
  belongs_to :coupon
end
