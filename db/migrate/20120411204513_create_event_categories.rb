class CreateEventCategories < ActiveRecord::Migration
  def change
    create_table :event_categories do |t|
      t.integer    :category_id     
      t.integer    :event_id

      t.timestamps
    end    
    add_index :event_categories, :category_id
    add_index :event_categories, :event_id
  end
end
