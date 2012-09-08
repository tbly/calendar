require 'spec_helper'

describe LocalNewsCategorization do
  subject { FactoryGirl.create(:local_news_categorization) }

  it { should validate_presence_of(:local_news_article_id) }

  it { should validate_presence_of(:local_news_category_id) }
  it { should validate_uniqueness_of(:local_news_category_id).scoped_to(:local_news_article_id) }

  it { should have_db_index(:local_news_article_id) }
  it { should have_db_index(:local_news_category_id) }

  it { should belong_to(:local_news_article) }
  it { should belong_to(:local_news_category) }
end
