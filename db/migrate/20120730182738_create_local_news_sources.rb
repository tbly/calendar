class CreateLocalNewsSources < ActiveRecord::Migration
  def change
    create_table :local_news_sources do |t|
      t.string :title, :null => false
      t.string :url, :null => false
      t.string :feed_url, :null => false
      t.string :etag, :null => false

      t.timestamps
    end

    add_index :local_news_sources, :feed_url, :unique => true
  end
end
