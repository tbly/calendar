require 'spec_helper'

describe LocalNewsCategory do
  subject { FactoryGirl.create(:local_news_category) }

  it { should validate_presence_of(:name) }

  it { should validate_uniqueness_of(:name) }
  it { should have_db_index(:name).unique(true) }

  it { should have_many(:local_news_articles).through(:local_news_categorizations) }
  it { should have_many(:local_news_categorizations).dependent(:destroy) }
end
