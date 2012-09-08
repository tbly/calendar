class CreateLocalNewsListings < ActiveRecord::Migration
  def change
    create_table :local_news_listings do |t|
      t.references :local_news_article
      t.references :local_news_source

      t.timestamps
    end

    add_index :local_news_listings, :local_news_article_id
    add_index :local_news_listings, :local_news_source_id
  end
end
