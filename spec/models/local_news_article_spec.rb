require 'spec_helper'

describe LocalNewsArticle do
  subject { FactoryGirl.create(:local_news_article) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:url) }
  it { should validate_presence_of(:author) }
  it { should validate_presence_of(:content) }
  it { should validate_presence_of(:guid) }

  it { should validate_uniqueness_of(:guid) }
  it { should have_db_index(:guid).unique(true) }

  it { should have_many(:local_news_sources).through(:local_news_listings) }
  it { should have_many(:local_news_listings).dependent(:destroy) }

  it { should have_many(:local_news_categories).through(:local_news_categorizations) }
  it { should have_many(:local_news_categorizations).dependent(:destroy) }

  describe 'creation from a feed entry' do
    before do
      @feed = nil
      File.open( 'spec/support/dumped_objects/feedzirra_feed.yaml', 'r' ) do |file|
        @feed = YAML::load( file.read )
      end

      @feed_entry = @feed.entries.first

      @source  = FactoryGirl.create( :local_news_source,
                                     :url => @feed.url,
                                     :feed_url => @feed.feed_url,
                                     :etag => @feed.etag )
    end

    context 'when the entry has never been seen before' do
      it 'should create a new local news article' do
        LocalNewsArticle.count.should == 0

        article = LocalNewsArticle.create_or_update_from_feed_entry( @feed_entry, @source )
        LocalNewsArticle.count.should == 1

        article.title.should == 'Developer plans office, housing for flood-hit Sullivan Bank'
        article.author.should == 'Rick Smith'
        article.guid.should == 'http://thegazette.com/?p=454767'
        article.url.should == 'http://feedproxy.google.com/~r/GazetteOnlineBreakingNews/~3/F3kthWZzTR0/'
        article.published_at.to_s.should == "2012-08-31 16:26:50 -0500"

        Digest::MD5.hexdigest( article.content ).should == 'a9989fa948adeaf649bd84d1e22b835f'

        article.local_news_sources.should == [@source]
        article.local_news_categories.map(&:name).sort.should == ["Business",
                                                                  "Flood Recovery",
                                                                  "Linn County Area",
                                                                  "Statewide News"]
      end
    end

    context 'when the entry has been seen before' do
      before do
        @article = LocalNewsArticle.create_or_update_from_feed_entry( @feed_entry, @source )
      end

      it 'should update relevant fields without creating a new article' do
        @feed_entry.title = "New Title"

        LocalNewsArticle.count.should == 1
        updated_article = LocalNewsArticle.create_or_update_from_feed_entry( @feed_entry, @source )
        LocalNewsArticle.count.should == 1

        updated_article.title.should == "New Title"
      end

      it 'should associate the article with a new source' do
        new_source  = FactoryGirl.create( :local_news_source,
                                          :url => @feed.url + "/some_new_url",
                                          :feed_url => @feed.feed_url + "/some_new_url",
                                          :etag => @feed.etag )

        updated_article = LocalNewsArticle.create_or_update_from_feed_entry( @feed_entry, new_source )
        updated_article.local_news_sources.should == [@source, new_source]
     end
    end
  end

  it 'should sanitize article content before validation' do
    subject.should be_valid

    subject.content = '<a href=\"http://www.link.com\">This is a test!</a>'

    subject.should be_valid
    subject.content.should eql( 'This is a test!' )
  end

  describe 'raw content parser' do
    before do
      @test_content = "<div id=\"attachment_441599\" class=\"wp-caption alignleft\"
                            style=\"width: 141px\">
                            <img class=\"size-medium wp-image-441599\"
                                 title=\"CAPTION IMAGE TITLE\"
                                 src=\"http://www.testurl.com/image.jpg\"
                                 alt=\"\" width=\"131\" height=\"225\" />
                            <p class=\"wp-caption-text\">IMAGE CAPTION TEXT</p>
                       </div>
                       <img class=\"test-class\"
                            src=\"http://www.testurl.com/image2.jpg\" />
                       <p>&nbsp;&nbsp;</p>
                       <p>FIRST PARAGRAPH TEXT</p>
                       <p>SECOND PARAGRAPH TEXT</p>"
    end

    context 'for text' do
      it 'should extract a reasonable default' do
        subject.content = nil
        subject.content.should be_nil

        subject.extract_text( @test_content )

        subject.content.should eql( 'FIRST PARAGRAPH TEXT' )
      end

      it 'should accept a block for custom parsing' do
        subject.content = nil
        subject.content.should be_nil

        subject.extract_text( @test_content ) do |doc|
          doc.should be_an_instance_of( Nokogiri::HTML::Document )
          doc.xpath('//p').last.inner_text
        end

        subject.content.should eql( 'SECOND PARAGRAPH TEXT' )
      end
    end

    context 'for image links' do
      it 'should extract an reasonable default' do
        subject.image_url = nil
        subject.image_url.should be_nil

        subject.extract_image( @test_content )

        subject.image_url.should eql( 'http://www.testurl.com/image.jpg' )
      end

      it 'should accept a block for custom parsing' do
        subject.image_url = nil
        subject.image_url.should be_nil

        subject.extract_image( @test_content ) do |doc|
          doc.should be_an_instance_of( Nokogiri::HTML::Document )
          doc.xpath('//img').last.attributes['src'].value
        end

        subject.image_url.should eql( 'http://www.testurl.com/image2.jpg' )
      end
    end
  end
end
