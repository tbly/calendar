class LocalNewsCategorization < ActiveRecord::Base
  validates :local_news_article_id, :presence => true
  validates :local_news_category_id, :presence => true,
                                     :uniqueness => { :scope => :local_news_article_id }

  belongs_to :local_news_article
  belongs_to :local_news_category
end
