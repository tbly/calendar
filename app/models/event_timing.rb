# t.date      :on_date
# t.string    :on_time
# t.integer   :duration      
# t.integer   :event_id 
# t.timestamps
      
class EventTiming < ActiveRecord::Base
  belongs_to :event
end
