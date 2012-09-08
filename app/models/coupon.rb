# t.string    :code
# t.date      :expire_date
# t.integer   :expire_type    
# t.integer   :event_id 
# t.timestamps
      
class Coupon < ActiveRecord::Base
  belongs_to :coupon_deal, :foreign_key => 'event_id'
  has_many :coupon_restrictions
end
