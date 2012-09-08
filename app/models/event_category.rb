# t.integer    :category_id     
# t.integer    :event_id
# t.timestamps

class EventCategory < ActiveRecord::Base
  belongs_to :event
  belongs_to :category
end
