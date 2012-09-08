class CreateLocalNewsArticles < ActiveRecord::Migration
  def change
    create_table :local_news_articles do |t|
      t.string :title, :null => false
      t.string :url, :null => false
      t.string :author, :null => false
      t.text :content, :null => false
      t.string :guid, :null => false
      t.datetime :published_at, :null => false
      t.string :image_url

      t.timestamps
    end

    add_index :local_news_articles, :guid, :unique => true
  end
end
