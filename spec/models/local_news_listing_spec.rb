require 'spec_helper'

describe LocalNewsListing do
  subject { FactoryGirl.create(:local_news_listing) }

  it { should validate_presence_of(:local_news_article_id) }

  it { should validate_presence_of(:local_news_source_id) }
  it { should validate_uniqueness_of(:local_news_source_id).scoped_to(:local_news_article_id) }

  it { should have_db_index(:local_news_article_id) }
  it { should have_db_index(:local_news_source_id) }

  it { should belong_to(:local_news_article) }
  it { should belong_to(:local_news_source) }
end
