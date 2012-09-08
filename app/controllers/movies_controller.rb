class MoviesController < ApplicationController
  # GET /movies
  # GET /movies.json
  def index
    @selected_date = calc_selected_date( params )

    # Get all showtimes for the selected date, grab all unique movie_id
    # values for the result set, then grab all movie records which
    # match those ids, ordered by movie title
    movie_ids = Showtime.where( :playing_on => @selected_date ).pluck( :movie_id ).uniq
    @movies = Movie.order( :title ).find_all_by_id( movie_ids )

    # Get all theaters, ordered by theater name
    @theaters = Theater.order( :name )
    @checked_theaters = ( params['theaters'] ) ? params['theaters'].map{|t| t.to_i} : @theaters.map{|t| t.id.to_i}

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @movies }
    end
  end

  # GET /movies/1
  # GET /movies/1.json
  def show
    @selected_date = calc_selected_date( params )

    @movie = Movie.find(params[:id])

    # Get all theaters, ordered by theater name
    @theaters = Theater.order( :name )
    @checked_theaters = ( params['theaters'] ) ? params['theaters'].map{|t| t.to_i} : @theaters.map{|t| t.id.to_i}

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @movie }
    end
  end

  private

  def calc_selected_date( params )
    # Get the date paramater data if it exists, or grab today's date
    # from the list of valid show dates, or the first valid showdate
    # if today isn't in the list for some reason
    selected_date_string = params[:date] || Showtime.show_date_today_or_first_unique.to_date.to_s
    selected_date = Date.strptime( selected_date_string, '%Y-%m-%d' )

    # Ensure that the date passed is in the list of valid show dates,
    # and if it's not, use the first valid show date
    unless Showtime.unique_show_dates.find{|show_date| show_date == selected_date}
      # TODO: Might want to alert the user that they manually
      #       specified an invalid date  --  Tue Jun  5 19:06:58 2012
      selected_date = Showtime.unique_show_dates.first.to_date
    end

    return selected_date
  end
end
