class HomeController < ApplicationController
  # GET /
  def index
    # Get the three most recent arrest records
    @recent_arrests = Arrest.order( 'date' ).limit( 3 )

    # Get movies that are new in theaters, checking the cache first
    now = DateTime.now
    minutes_to_end_of_day = ((now.end_of_day - now) * 60 * 24).to_i.minutes

    # OPTIMIZE: This would be a *great* candidate for caching since
    # @movies won't change more than once per day. Couldn't get the
    # caching mechanism working, though. I'll take another crack at it
    # later.  --  Mon Aug 20 23:04:27 2012
    @movies = Movie.newly_playing_movies_today( 3 )

    respond_to do |format|
      format.html # index.html.erb
    end
  end
end
