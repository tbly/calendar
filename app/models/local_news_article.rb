class LocalNewsArticle < ActiveRecord::Base
  attr_accessible :author, :content, :image_url,
                  :title, :url, :guid, :published_at

  #----------------------------------------------------------------------------
  # Validations
  #----------------------------------------------------------------------------
  validates :author, :presence => true
  validates :content, :presence => true
  validates :title, :presence => true
  validates :url, :presence => true
  validates :published_at, :presence => true
  validates :guid, :presence => true, :uniqueness => true

  #----------------------------------------------------------------------------
  # Relations
  #----------------------------------------------------------------------------
  has_many :local_news_listings, :dependent => :destroy
  has_many :local_news_sources, :through => :local_news_listings

  has_many :local_news_categorizations, :dependent => :destroy
  has_many :local_news_categories, :through => :local_news_categorizations

  #----------------------------------------------------------------------------
  # Callbacks
  #----------------------------------------------------------------------------
  before_validation :sanitize_content

  #----------------------------------------------------------------------------
  # Instance Methods
  #----------------------------------------------------------------------------
  def extract_text( raw_content )
    # Parse the raw content with the assumption that it's raw HTML'
    parsed_content = Nokogiri::HTML( raw_content )

    # Yield to the block, if passed, to determine the text content,
    # otherwise attempt to extract a sensible default
    text_content = ''

    if block_given?
      text_content = yield parsed_content
    else
      # Get the first paragraph that isn't part of an image caption or
      # whitespace
      paragraph_elements = parsed_content.xpath('//p')
      paragraph_elements.each do |paragraph_element|
        # Skip this paragraph if it's an image caption'
        next if paragraph_element.values.include?('wp-caption-text')

        # Skip this paragraph if it's nothing but whitespace
        next if paragraph_element.inner_text.blank?

        # Should be at the first valid, non-whitespace paragraph, so
        # save the content, and then break from the search
        text_content = paragraph_element.inner_text
        break
      end
    end

    if text_content.present?
      # Sanitize the content and strip leading and trailing whitespace
      self.content = Sanitize.clean( text_content ).strip
    end

 end

  def extract_image( raw_content )
    # Parse the raw content with the assumption that it's raw HTML'
    parsed_content = Nokogiri::HTML( raw_content )

    # Yield to the block, if passed, to determine the image url content,
    # otherwise attempt to extract a sensible default
    image_url_content = ''

    if block_given?
      image_url_content = yield parsed_content
    else
      # First look for a caption tag and if it's found, extract the
      # immediately preceding image tag'
      image_element = parsed_content.at('//p[contains(@class,"wp-caption-text")]/preceding::img')

      # If nothing was found, attempt to find the first image, if any,
      # which has dimensions greater than 100px x 100px
      image_element ||= parsed_content.at('//img[@width > 100 and @height > 100]')

      # Set the image_url if an appropriate image was found
      image_url_content = image_element.attributes['src'].value if image_element
    end

    self.image_url = image_url_content
  end

  class << self
    def create_or_update_from_feed_entry( entry, source, log_enabled = false )
      log = Rails.logger

      attributes = {
        :title => entry.title,
        :author => entry.author,
        :url => entry.url,
        :published_at => entry.published
      }

      article = LocalNewsArticle.find_or_initialize_by_guid( entry.id )
      article.assign_attributes( attributes )

      # Extract the article text and image link from the raw feed
      # entry content, passing an optional eigenblock (ha!) based
      # on the context provided by the LocalNewsSource instance
      article.extract_text( entry.content, &source.text_parser )
      article.extract_image( entry.content, &source.image_parser )

      # If article content is still empty, use the feed entry
      # title as the article content as a last resort
      article.content = entry.title if article.content.blank?

      if article.save
        # Check to see if this source has referenced this article
        # before, and if not add it
        unless article.local_news_sources.exists?( source )
          article.local_news_sources << source
        end

        # Set up the article categories
        entry.categories.each do |category|
          category = LocalNewsCategory.find_or_create_by_name( category )

          unless article.local_news_categories.exists?( category )
            article.local_news_categories << category
          end
        end
      end

      article.valid? ? article : nil
    end
  end

  #----------------------------------------------------------------------------
  # Private Instance Methods
  #----------------------------------------------------------------------------
  private

  def sanitize_content
    self.content = Sanitize.clean( content ).strip if self.content.present?
  end
end
