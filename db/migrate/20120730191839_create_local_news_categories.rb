class CreateLocalNewsCategories < ActiveRecord::Migration
  def change
    create_table :local_news_categories do |t|
      t.string :name

      t.timestamps
    end

    add_index :local_news_categories, :name, :unique => true
  end
end
