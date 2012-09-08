require 'spec_helper'

describe LocalNewsSource do
  subject { FactoryGirl.create(:local_news_source) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:url) }
  it { should validate_presence_of(:feed_url) }
  it { should validate_presence_of(:etag) }

  it { should validate_uniqueness_of(:feed_url) }
  it { should have_db_index(:feed_url).unique(true) }

  it { should have_many(:local_news_articles).through(:local_news_listings) }
  it { should have_many(:local_news_listings).dependent(:destroy) }

  describe 'creating a source from a RSS url' do
    before do
      @feed = nil
      File.open( 'spec/support/dumped_objects/feedzirra_feed.yaml', 'r' ) do |file|
        @feed = YAML::load( file.read )
      end

      Feedzirra::Feed.stub(:fetch_and_parse).and_return(@feed)
    end

    it 'should create a source from an RSS url' do
      source = LocalNewsSource.create_from_url('http://feeds.feedburner.com/GazetteOnlineBreakingNews?format=xml')

      source.feed_url.should == 'http://feeds.feedburner.com/GazetteOnlineBreakingNews?format=xml'
      source.etag.should == 'Sp0ugPnyt/U2FhDSFcLjb3uOzEc'
      source.title.should == 'Breaking News from GazetteOnline'
      source.url.should == 'http://thegazette.com'
    end
  end
end
