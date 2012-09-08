# t.string    :venue_name
# t.string    :street
# t.string    :city
# t.string    :street
# t.string    :state
# t.string    :zip
# t.float     :lat      
# t.float     :lng      
# t.integer   :event_id      
# t.timestamps
      
class EventLocation < ActiveRecord::Base
  belongs_to :event
end
