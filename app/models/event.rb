# t.string    :type
# t.integer   :user_id      
# t.string    :title
# t.text      :description
# t.string    :cost
# t.boolean   :is_family_event, :default => false
# t.string    :business_name
# t.string    :contact_phone
# t.string    :contact_website
# t.string    :contact_email
# t.integer   :event_type
# t.string    :status
# t.timestamps
      
class Event < ActiveRecord::Base
  STATUSES = ['AWAITING PREVIEW','PENDING PAYMENT','CANCELLED','APPROVED','REJECTED']
  
  belongs_to :user
  has_many :event_categories
  has_many :categories, :through => :event_categories
  has_many :event_locations
  has_many :event_timings
  has_many :image_attachments, :as => :attachable, :dependent => :destroy
end
