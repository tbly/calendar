class CreateLocalNewsCategorizations < ActiveRecord::Migration
  def change
    create_table :local_news_categorizations do |t|
      t.references :local_news_article
      t.references :local_news_category

      t.timestamps
    end

    add_index :local_news_categorizations, :local_news_article_id
    add_index :local_news_categorizations, :local_news_category_id
  end
end
