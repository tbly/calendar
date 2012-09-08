module ArrestHelper
  # TODO: Determine if this is useful  --  Tue Jul 17 23:32:17 2012
  def sort_options(sortby)
    if sortby == "date"
     ret = "Sort by Date"
    ret << " | "
      ret << link_to('Sort by Name', { :action => 'index', :sort => 'name' })
    elsif sortby == "name"
      ret = link_to('Sort by Date', { :action => 'index', :sort => 'date' })
     ret << " | "
     ret << 'Sort by Name'
    else
     ret = "Sort by Date"
     ret << " | "
      ret << link_to('Sort by Name', { :action => 'index', :sort => 'name' })
    end

  end

  def format_info( arrest )
    action = ( arrest.cited? ) ? 'Cited' : 'Arrested'
    "<p>Age #{ arrest.age }, of #{ arrest.address }: #{ action } at #{ arrest.location } on #{ arrest.date.strftime( '%A, %b %e, %Y' ) }</p>".html_safe
  end

  def format_charges(charges)
    ret = "<ul class=\"arrest-charges\">"

    count = 1
    flag = false
    ch = Array.new
    pos1 = 0
    pos2 = 0

    while flag == false
      if charges.index(count.to_s+")")
        pos1 = charges.index(count.to_s+")")
        nextcount = count + 1
        if charges.index(nextcount.to_s + ")")
          pos2 = charges.index(nextcount.to_s + ")")
          ch[count-1] = charges[pos1+2, pos2-pos1-2]
        else
          ch[count-1] = charges[pos1+2, charges.length]
          flag = true
        end
      else
        flag = true
      end
      count = count + 1
    end

    ch.each do |charge|
      ret << "  <li>#{charge}</li>"
    end

    ret << "</ul>"

    ret.html_safe
  end

  def format_arrest_date( arrest_date )
    output = (arrest_date.today?) ? 'Today, ' : ''
    output << arrest_date.strftime( '%A, %b %e, %Y' )
  end
end
