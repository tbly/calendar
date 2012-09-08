class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string    :type
      t.integer   :user_id      
      t.string    :title
      t.text      :description
      t.string    :cost
      t.boolean   :is_family_event, :default => false
      t.string    :business_name
      t.string    :contact_phone
      t.string    :contact_website
      t.string    :contact_email
      t.integer   :event_type
      t.string    :status

      t.timestamps
    end
    add_index :events, :user_id
    add_index :events, :type
  end
end
