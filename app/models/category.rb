# t.string    :category_type      
# t.string    :name
# t.text      :description      
# t.timestamps
      
class Category < ActiveRecord::Base
  has_many :event_categories
  has_many :events, :through => :event_categories
end
