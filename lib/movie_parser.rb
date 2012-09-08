require 'movie_parser/file_utility'
require 'movie_parser/image'

module MovieParser
  #----------------------------------------------------------------------------
  # Module Constants
  #----------------------------------------------------------------------------
  ASSETS_ROOT_PATH = Rails.root.join( 'lib', 'assets', 'movie_files' )
  ASSETS_TEMP_PATH = Rails.root.join( 'tmp', 'movie_files' )

  #----------------------------------------------------------------------------
  # Module Methods
  #----------------------------------------------------------------------------
  def self.today
    Time.now.strftime( "%y%m%d" )
  end

  #----------------------------------------------------------------------------
  # Classes
  #----------------------------------------------------------------------------
  class Parser

    #----------------------------------------------------------------------------
    # Public Instance Methods
    #----------------------------------------------------------------------------
    def parse_xml
      # Wrap all record operations in a transaction
      ActiveRecord::Base.transaction do
        # Update Movie records
        movie_xml = get_xml( ASSETS_TEMP_PATH.join( 'movies.xml' ) )
        movie_xml.xpath( '//movies/movie' ).each do |movie_element|
          # Map element data to model attribute hash
          attributes = map_movie_attributes( movie_element )

          # Find the movie record using the cinema source id if it exists, or else
          # init a new record
          movie = Movie.find_or_initialize_by_cs_id( attributes[:cs_id] )

          # Filter out any unchanged serialized field data from
          # attributes hash
          attributes = filter_unchanged_serialized( movie, attributes )

          # Update and save the record's attributes
          movie.assign_attributes( attributes )
          movie.save! if movie.valid? && movie.changed?
        end

        # Update Theater Records
        theater_xml = get_xml( ASSETS_TEMP_PATH.join( 'theaters.xml' ) )
        theater_xml.xpath('//houses/theater').each do |theater_element|
          # Map element data to model attribute hash
          attributes = map_theater_attributes( theater_element )

          # Find the theater record using the cinema source id if it
          # exists, or else init a new record
          theater = Theater.find_or_initialize_by_cs_id( attributes[:cs_id] )

          # Filter out any unchanged serialized field data from
          # attributes hash
          attributes = filter_unchanged_serialized( theater, attributes )

          # Update and save the record's attributes
          theater.assign_attributes( attributes )
          theater.save! if theater.valid? && theater.changed?
        end

        # Update Showtime Records
        showtimes_xml = get_xml( ASSETS_TEMP_PATH.join( 'showtimes.xml' ) )
        showtimes_xml.xpath('//times/showtime').each do |showtime_element|
          # Map element data to model attribute hash
          attributes = map_showtime_attributes( showtime_element )

          # Iterate over each show date in the showtime element
          showtime_element.xpath( './/show_date' ).each do |show_date_element|
            attributes.merge!( map_show_date_attributes( show_date_element ) )

            # Parse the showtime link data and create a new showtime
            # record for each listed showtime
            parse_showtime_links( show_date_element ).each do |link_data|
              playing_at, bargain_flag, link = link_data

              attributes[:playing_at] = playing_at
              attributes[:playing_on] = playing_at.to_date
              attributes[:bargain]    = bargain_flag
              attributes[:link]       = link

              # Find the showtime record using the playing_at datetime,
              # movie_id, and theater_id if it exists, or else init a new record
              showtime = Showtime.find_or_initialize_by_movie_id_and_theater_id_and_playing_at( attributes[:movie_id],
                                                                                                attributes[:theater_id],
                                                                                                playing_at )

              # Filter out any unchanged serialized field data from
              # attributes hash
              attributes = filter_unchanged_serialized( showtime, attributes )

              # Update and save the record's attributes
              showtime.assign_attributes( attributes )
              showtime.save! if showtime.valid? && showtime.changed?
            end
          end
        end
      end
    end

    #----------------------------------------------------------------------------
    # Class Methods
    #----------------------------------------------------------------------------
    class << self
      def import_movies( today = MovieParser.today, skip_download = false )
        begin
          # Init the file utility lib and movie parser
          movie_file_util = MovieParser::FileUtility.new( today )
          movie_parser    = MovieParser::Parser.new

          # Pull down the files
          movie_file_util.download_raw_data unless skip_download

          # Create backups and unpack the downloads
          movie_file_util.unpack_photos
          movie_file_util.unpack_xml

          # Parse the XML
          print 'Parsing and loading .xml files...'
          movie_parser.parse_xml
          puts ' done!'

          # Create thumbnails out of images
          print 'Making thumbs out of the main images...'
          imgs = MovieParser::Image.get_all_images
          imgs.each do |img|
            i = MovieParser::Image.new( img )
            i.make_thumb
          end
          puts ' done!'
        rescue MovieParser::FileUtilityError
          # TODO: Handle error case here  --  Sun Aug 19 15:12:33 2012
        end
      end
    end

    #----------------------------------------------------------------------------
    # Private Instance Methods
    #----------------------------------------------------------------------------
    private

    def filter_unchanged_serialized( record, attributes )
      record.serialized_attributes.keys.map(&:to_sym).each do |field|
        value = record[field]
        attributes.delete(field) if value == attributes[field]
      end

      attributes
    end

    # Read an XML file using Nokogiri
    def get_xml( file )
      # NOTE: Raises Errno::ENOENT if file is not found
      Nokogiri::XML( IO.read( file ) )
    end

    # Map movie record field names to XML elements
    def map_movie_attributes( movie_element )
      attributes = {}

      # Required
      attributes[:title] = movie_element.xpath('./title').text
      attributes[:cs_id] = movie_element.xpath('./movie_id').text.to_i

      # Single values
      attributes[:rating] = movie_element.xpath('./rating').text
      attributes[:advisory] = movie_element.xpath('./advisory').text
      attributes[:running_time] = movie_element.xpath('./running_time').text.to_i
      attributes[:official_site] = movie_element.xpath('./official_site').text
      attributes[:distributor] = movie_element.xpath('./distributor').text
      attributes[:summary] = movie_element.xpath('./review').text
      attributes[:stars] = movie_element.xpath('./stars').text
      attributes[:review] = movie_element.xpath('./holreview').text

      # Array values
      attributes[:photos] = movie_element.xpath('./photos').map(&:text)
      attributes[:high_quality_photos] = movie_element.xpath('./hiphotos').map(&:text)
      attributes[:genres] = movie_element.xpath('./genre').map(&:text)
      attributes[:cast] = movie_element.xpath('./cast').map(&:text)
      attributes[:directors] = movie_element.xpath('./director').map(&:text)
      attributes[:producers] = movie_element.xpath('./producer').map(&:text)
      attributes[:writers] = movie_element.xpath('./writer').map(&:text)

      # Hash values
      release_date_list = movie_element.xpath("./release_date").map do |rd|
        [Date.parse( rd.text ), rd['notes']]
      end

      attributes[:release_dates] = Hash[release_date_list]

      # Strip all pairs with blank values
      attributes.reject{|key, value| value.class == String && value.blank?}
    end

    def map_theater_attributes( theater_element )
      attributes = {}

      # Required
      attributes[:cs_id] = theater_element.xpath("./theater_id").text.to_i
      attributes[:name] = theater_element.xpath("./theater_name").text
      attributes[:address] = theater_element.xpath("./theater_address").text
      attributes[:city] = theater_element.xpath("./theater_city").text
      attributes[:state] = theater_element.xpath("./theater_state").text
      attributes[:zip] = theater_element.xpath("./theater_zip").text
      attributes[:phone] = theater_element.xpath("./theater_phone").text
      attributes[:county] = theater_element.xpath("./theater_county").text
      attributes[:ticketing] = theater_element.xpath("./theater_ticketing").text == 'Y'

      # Single values
      attributes[:theater_attributes] = theater_element.xpath("./theater_attributes").text
      attributes[:closed_reason] = theater_element.xpath("./theater_closed_reason").text
      attributes[:area] = theater_element.xpath("./theater_area").text
      attributes[:location] = theater_element.xpath("./theater_location").text
      attributes[:market] = theater_element.xpath("./theater_market").text
      attributes[:screens] = theater_element.xpath("./theater_screens").text.to_i
      attributes[:seating] = theater_element.xpath("./theater_seating").text
      attributes[:adult_price] = theater_element.xpath("./theater_adult").text
      attributes[:child_price] = theater_element.xpath("./theater_child").text
      attributes[:senior_price] = theater_element.xpath("./theater_senior").text
      attributes[:adult_bargain_price] = theater_element.xpath("./theater_adult_bargain").text
      attributes[:price_comment] = theater_element.xpath("./theater_price_comment").text
      attributes[:sound] = theater_element.xpath("./theater_sound").text
      attributes[:latitude] = theater_element.xpath("./theater_lat").text
      attributes[:longitude] = theater_element.xpath("./theater_lon").text

      # Strip all pairs with blank values
      attributes.reject{|key, value| value.class == String && value.blank?}
    end

    def map_showtime_attributes( showtime_element )
      attributes = {}

      # Find the movie and theater records referenced by the
      # showtime element using the given cinema source id
      movie_cs_id   = showtime_element.xpath('./movie_id').text.to_i
      theater_cs_id = showtime_element.xpath('./theater_id').text.to_i

      movie   = Movie.find_by_cs_id( movie_cs_id )
      theater = Theater.find_by_cs_id( theater_cs_id )

      attributes[:movie_id]   = movie.id
      attributes[:theater_id] = theater.id

      # Strip all pairs with blank values
      attributes.reject{|key, value| value.class == String && value.blank?}
    end

    def map_show_date_attributes( show_date_element )
      attributes = {}

      # Required
      attributes[:passes]     = show_date_element.xpath('./show_passes').text == 'Y'
      attributes[:festival]   = show_date_element.xpath('./show_festival').text == 'Y'

      # Single values
      attributes[:showtime_attributes] = show_date_element.xpath('./show_attributes').text
      attributes[:show_with] = show_date_element.xpath('./show_with').text
      attributes[:sound] = show_date_element.xpath('./show_sound').text
      attributes[:comments] = show_date_element.xpath('./show_comments').text

      # Strip all pairs with blank values
      attributes.reject{|key, value| value.class == String && value.blank?}
    end


    def parse_showtime_links( show_date_element )
      link_data = []
      date = show_date_element['date']

      # Links given in CDATA array of comma-delimited pairs consisting
      # of a showtime and a movietickets.com URL, so split on commas
      # and build a hash out of the resulting array of values
      time_link_hash =  Hash[*show_date_element.xpath('./showtimes').text.split(/,/)]

      # Iterate over each data pair
      time_link_hash.each_pair do |time, link|
        # Calculate the playing_at time
        datetime_string = "#{date} #{time.gsub(/[\(\)]/, '')}"
        playing_at = DateTime.strptime( datetime_string, '%Y%m%d %H:%M' )

        # Determine if the given time is a bargain (matinee) time
        # based on the presence of an opening parenthesis in the formatting
        bargain_flag = time.include?("(")

        link_data << [ playing_at, bargain_flag, link ]
      end

      link_data
    end
  end
end
