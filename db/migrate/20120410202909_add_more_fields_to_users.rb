class AddMoreFieldsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :name, :string
    add_column :users, :phone, :string    
    
    User.reset_column_information    
  end

  def self.down
    remove_column :users, :name
    remove_column :users, :phone
    
    User.reset_column_information
  end
end
