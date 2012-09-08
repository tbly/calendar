class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string    :category_type      
      t.string    :name
      t.text      :description      

      t.timestamps
    end    
  end
end
