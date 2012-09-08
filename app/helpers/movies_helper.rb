module MoviesHelper
  def select_date_options( selected_date )
    option_array = Showtime.unique_show_dates.map{|d| [ d.to_date.to_formatted_s( :long_ordinal ), d.to_date.to_s ]}
    options_for_select( option_array, selected_date )
  end

  def showtime_list_items( movie, theater, date )
    list_items_markup = "".html_safe

    showtimes = movie.showtimes.where( :theater_id => theater.id, :playing_on => date )

    # TODO: Handle potential case where showtime isn't found for given
    #       movie/show_date, for now just return the empty markup string
    return list_items_markup if showtimes.blank?

    # TODO: Refactor CSS classes to set color on bargin links  --  Sat Aug 18 23:50:50 2012
    showtimes.each_with_index do |showtime, index|
      if index == 0
        list_items_markup << ('<li class="firstmovietime" id="paranthlink">' + format_showtime_link( showtime ) + '</li>').html_safe
      elsif index == ( showtimes.count - 1 )
        list_items_markup << ('<li class="lastmovietime">' + format_showtime_link( showtime ) + '</li>').html_safe
      else
        list_items_markup << ('<li>' + format_showtime_link( showtime ) + '</li>').html_safe
      end
    end

    return list_items_markup.html_safe
  end

  def format_showtime_link( showtime )
    link_text = showtime.playing_at.strftime("%H:%M")
    link_markup = link_to( link_text, showtime.link )

    link_markup = "(#{link_markup})".html_safe if showtime.bargain?
    link_markup
  end

  def format_genres( movie )
    movie.genres.join(', ')
  end

  def format_rating( movie )
    ( movie.rating == 'No Rating' ) ? 'No Rating' : "Rated #{movie.rating}"
  end

  def format_theater_info( theater )
    address_1 = theater.address
    address_2 = "#{theater.city}, #{theater.state}  #{theater.zip}"
    info = theater.theater_attributes

    [address_1, address_2, info].join('<br />').html_safe
  end

  def format_theater_name( theater )
    # Remove "Marcus" substring from theater name
    theater.name.gsub(/Marcus /, '')
  end

  def format_running_time( movie )
    "#{movie.running_time/60} hrs #{movie.running_time % 60} mins"
  end

  def format_cast( movie )
    movie.cast.join(', ')
  end

  def format_directors( movie )
    movie.directors.join(', ')
  end

  def format_release_type( movie, date )
    release_type = nil

    case movie.release_dates[date]
    when 'Limited'
      release_type = 'Sneak Preview'
    else
      release_type = ''
    end

    release_type
  end

  def show_release_type?( movie, date )
    highlighted_types = ['Limited']
    highlighted_types.include?( movie.release_dates[date] )
  end
end
