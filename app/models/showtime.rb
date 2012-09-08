class Showtime < ActiveRecord::Base
  include VersionedAttributes

  belongs_to :theater
  belongs_to :movie

  validates :movie_id,   :presence => true
  validates :theater_id, :presence => true
  validates :playing_at, :presence => true
  validates :playing_on, :presence => true
  validates :link,       :presence => true
  validates :bargain,    :inclusion => { :in => [true, false] }
  validates :passes,     :inclusion => { :in => [true, false] }
  validates :festival,   :inclusion => { :in => [true, false] }

  def new_version_id
    DateTime.now.strftime( "%y%m%d" )
  end

  class << self
    def unique_show_dates
      Showtime.pluck(:playing_on).uniq.sort
    end

    def show_date_today_or_first_unique
      found_date = Showtime.unique_show_dates.find{|show_date| show_date == Date.today}
      found_date ||= Showtime.unique_show_dates.first

      return found_date
    end
  end
end
