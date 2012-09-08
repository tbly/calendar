class LocalNewsSource < ActiveRecord::Base
  attr_accessible :etag, :feed_url, :title, :url

  #----------------------------------------------------------------------------
  # Validations
  #----------------------------------------------------------------------------
  validates :etag, :presence => true
  validates :feed_url, :presence => true, :uniqueness => true
  validates :title, :presence => true
  validates :url, :presence => true

  #----------------------------------------------------------------------------
  # Relations
  #----------------------------------------------------------------------------
  has_many :local_news_listings, :dependent => :destroy
  has_many :local_news_articles, :through => :local_news_listings

  #----------------------------------------------------------------------------
  # Instance Methods
  #----------------------------------------------------------------------------
  def text_parser
    # Based on the url of the feed (not the feed_url!), return a proc
    # which operates on a Nokogiri::HTML::Document object and returns
    # the appropriate text content for an article from this source
    parser_proc = nil

    case self.url
    when 'http://thegazette.com'
      # TODO: Any specific handling for this source --  Mon Jul 30 21:44:19 2012
    when 'http://www.dailyiowan.com'
      # TODO: Any specific handling for this source --  Mon Jul 30 21:44:19 2012
    when 'http://www.press-citizen.com'
    when 'http://www.hawkcentral.com'
      # TODO: Any specific handling for this source --  Mon Jul 30 21:44:19 2012
    when 'http://www.kwwl.com/category/176430/mobile-news'
    when 'http://www.kwwl.com/category/176430/sports'
    when 'http://www.kwwl.com/category/176430/national-news'
    when 'http://www.kwwl.com/category/176430/decision-2012'
      # TODO: Any specific handling for this source --  Mon Jul 30 21:44:19 2012
    else
      # Example:
      # parser_proc = lambda do |doc|
      #   Sanitize.clean( doc.at('//p').inner_text )
      # end
    end

    return parser_proc
  end

  def image_parser
    # Based on the url of the feed (not the feed_url!), return a proc
    # which operates on a Nokogiri::HTML::Document object and returns
    # the appropriate image url content for an article from this source
    parser_proc = nil

    case self.url
    when 'http://thegazette.com'
      # TODO: Any specific handling for this source --  Mon Jul 30 21:44:19 2012
    when 'http://www.dailyiowan.com'
      # TODO: Any specific handling for this source --  Mon Jul 30 21:44:19 2012
    when 'http://www.press-citizen.com'
    when 'http://www.hawkcentral.com'
      # TODO: Any specific handling for this source --  Mon Jul 30 21:44:19 2012
    when 'http://www.kwwl.com/category/176430/mobile-news'
    when 'http://www.kwwl.com/category/176430/sports'
    when 'http://www.kwwl.com/category/176430/national-news'
    when 'http://www.kwwl.com/category/176430/decision-2012'
      # TODO: Any specific handling for this source --  Mon Jul 30 21:44:19 2012
    else
      # Example:
      # parser_proc = lambda do |doc|
      #   doc.at('//img').attributes['src'].value
      # end
    end

    return parser_proc
  end

  #----------------------------------------------------------------------------
  # Class Methods
  #----------------------------------------------------------------------------
  class << self
    def create_from_url( url )
      feed = Feedzirra::Feed.fetch_and_parse( url )

      attributes = {
        :feed_url => feed.feed_url,
        :etag     => feed.etag,
        :title    => feed.title,
        :url      => feed.url
      }

      LocalNewsSource.create( attributes )
    end

    def parse_all_feeds( log_enabled = false )
      log = Rails.logger
      successfully_parsed_sources = []

      # Iterate through all known local news sources to find updated
      # article data and create or update data as necessary
      LocalNewsSource.all.each do |source|
        log.info "Parsing feed: #{source.feed_url}" if log_enabled
        feed = Feedzirra::Feed.fetch_and_parse( source.feed_url )

        # Feed could not be found and/or parsed
        unless feed
          log.info "Parse of #{source.feed_url} failed" if log_enabled
          next
        end

        # Iterate over all of the feed entries looking for new article data
        feed.entries.each do |entry|
          article = LocalNewsArticle.create_or_update_from_feed_entry( entry, source, log_enabled )

          unless article.present?
            log.info "Failed to create entry on #{source.feed_url}"
          end
        end

        log.info "Parse of #{source.feed_url} succeeded" if log_enabled

        # Update the etag of the news source with the feed etag
        # NOTE: Etags not currently in use, but may be useful in future
        # optimization to limit the amount of redundant update traffic
        source.update_attribute( :etag, feed.etag )
        successfully_parsed_sources << source
      end

      successfully_parsed_sources
    end
  end
end
