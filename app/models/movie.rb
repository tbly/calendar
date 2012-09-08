class Movie < ActiveRecord::Base
  include VersionedAttributes

  serialize :photos, Array
  serialize :high_quality_photos, Array
  serialize :genres, Array
  serialize :cast, Array
  serialize :directors, Array
  serialize :release_dates, Hash
  serialize :producers, Array
  serialize :writers, Array

  has_many :showtimes
  has_many :theaters, :through => :showtimes, :uniq => true

  validates :cs_id, :presence => true, :numericality => { :only_integer => true }
  validates :title, :presence => true

  #----------------------------------------------------------------------------
  # Class Constants
  #----------------------------------------------------------------------------
  VALID_RELEASE_TYPES = [ 'Nationwide', 'Limited', 'Live', 'SNEAKS' ]

  #----------------------------------------------------------------------------
  # Public Instance Methods
  #----------------------------------------------------------------------------
  def new_version_id
    DateTime.now.strftime( "%y%m%d" )
  end

  def theaters_showing_on( date )
    self.showtimes.where( :playing_on => date ).all.map(&:theater).uniq
  end

  def showtimes_remaining_today?
    date_range = DateTime.now..DateTime.now.end_of_day
    remaining_count = self.showtimes.where( :playing_at => date_range ).count
    (remaining_count > 0)
  end

  def showtimes_remaining?
    remaining_count = self.showtimes.where( 'playing_at > ?', DateTime.now ).count
    (remaining_count > 0)
  end

  def newly_playing_showtime_on( date )
    # If any releases which are within the last week and have a
    # valid release type are found, and is playing at a known theater,
    # and has some future showtime remaining, it is newly released
    playing_date, playing_note = self.release_dates.find do |release_date, note|
      date_delta = (date.to_date - release_date.to_date).to_i

      (0..7).include?( date_delta ) &&
        VALID_RELEASE_TYPES.include?( note ) &&
        self.showtimes_remaining?
    end

    playing_date
  end

  def newly_playing_on?( date )
    self.newly_playing_showtime_for( date ).present?
  end

  def newly_playing_for_today?
    self.newly_playing_for?( Date.today )
  end

  #----------------------------------------------------------------------------
  # Class Methods
  #----------------------------------------------------------------------------
  class << self
    def newly_playing_movies_today( limit = 5 )
      movie_releases = Movie.all.map do |m|
        [ m, m.newly_playing_showtime_on( Date.today ) ]
      end

      movie_releases.reject!{|mr| mr.last.nil?}

      movie_releases.sort! do |a,b|
        release_date_a = a.last
        release_date_b = b.last

        release_date_a <=> release_date_b
      end

      movie_releases.last( limit )
    end
  end
end
