class LocalNewsCategory < ActiveRecord::Base
  attr_accessible :name

  validates :name, :presence => true, :uniqueness => true

  has_many :local_news_categorizations, :dependent => :destroy
  has_many :local_news_articles, :through => :local_news_categorizations
end
