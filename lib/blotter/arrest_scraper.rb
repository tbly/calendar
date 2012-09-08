require 'nokogiri'
require 'open-uri'

module Blotter
  class ArrestDay
    attr_accessor :date, :consume_url, :arrests, :error

    def initialize( date, consume_url, arrests = [] )
      @date = date
      @consume_url = consume_url
      @arrests = arrests
    end
  end

  class ArrestScraper
    attr_accessor :date, :number_of_days, :base_url

    BLOTTER_URL = 'http://www.iowa-city.org/icgov/apps/police/blotter.asp'

    def initialize( number_of_days = 0, date = Date.today, base_url = BLOTTER_URL )
      @date = date
      @number_of_days = number_of_days
      @base_url = base_url
    end

    def process
      results = [process_url(@date)]
      (1..@number_of_days).each do |d|
        results << process_url( @date - d )
      end

      return results
    end

    class << self
      def import_arrest_data( previous_days = 0, date = Date.today )
        arrest_scraper = Blotter::ArrestScraper.new( previous_days, date )
        results = arrest_scraper.process

        results.each do |arrest_day|
          if arrest_day.error.present?
            Rails.logger.info "Collect data error on #{arrest_day.date.strftime('%m/%d/%Y')}: #{arrest_day.error}"
            next
          end

          arrest_day.arrests.each do |arrest|
            if arrest.error.blank?
              age = Time.now.to_date.year - arrest.dob.year
              age -= 1 unless Time.now.to_date < arrest.dob

              model = Arrest.new( :name     => arrest.name,
                                  :address  => arrest.address,
                                  :date     => arrest.date,
                                  :dob      => arrest.dob,
                                  :age      => age,
                                  :location => arrest.location,
                                  :incident => arrest.incident,
                                  :cited    => arrest.ca == "C",
                                  :arrested => arrest.ca == "A",
                                  :charges  => arrest.charges )

              if model.save
                Rails.logger.info "Imported Arrest incident #{model.incident}"
              else
                Rails.logger.info "#{model.incident} not valid because #{model.errors.full_messages}"
              end
            else
              Rails.logger.info "Arrest incident #{arrest.incident}: #{arrest.error}, it is ignored, please check."
            end
          end
        end
      end
    end

    private

    def process_url(calc_date)
      url = @base_url + '?date=' + calc_date.strftime("%m%d%Y")
      arrest_day = ArrestDay.new(calc_date, url, [])
      arrest_class = Struct.new(:name, :address, :date, :dob, :location, :incident, :ca, :charges, :error)

      begin
        doc = Nokogiri::HTML(open(url).read)
        doc.css('table.full > tbody > tr').each_with_index do |node, idx|
          if idx > 0
            td_elements = node.css('td')
            if td_elements[0]['colspan'].nil? # No arrests found.
              arrest = arrest_class.new
              begin
                td = td_elements[0]
                arrest.name = td.css('strong').text.strip
                arrest.address = td.inner_html.split('<br>')[1].strip
              rescue Exception => exc
                arrest.error = "Error on parsing name: #{exc.message}"
              end
              begin
                td = td_elements[1]

                date = td.css('strong').text.gsub(/[[:space:]]/, ' ').strip
                dob = td.inner_html.split('<br>')[1].strip.gsub('dob : ','')

                arrest.date = DateTime.strptime( date, '%m/%d/%Y %H:%M' )
                arrest.dob  = DateTime.strptime( dob,  '%m/%d/%Y' )
              rescue Exception => exc
                arrest.error = "Error on parsing date/dob: #{exc.message}"
              end
              begin
                arrest.location = td_elements[2].text.strip
              rescue Exception => exc
                arrest.error = "Error on parsing location: #{exc.message}"
              end
              begin
                arrest.incident = td_elements[3].text.strip
              rescue Exception => exc
                arrest.error = "Error on parsing incident: #{exc.message}"
              end
              begin
                arrest.ca = td_elements[4].text.strip
              rescue Exception => exc
                arrest.error = "Error on parsing incident: #{exc.message}"
              end
              begin
                arrest.charges = td_elements[5].inner_html.gsub('<br>',"\n").strip
              rescue Exception => exc
                arrest.error = "Error on parsing charges: #{exc.message}"
              end
              arrest_day.arrests << arrest
            end unless td_elements.nil?
          end
        end
      rescue Exception => exc
        arrest_day.error = exc.message
      end

      return arrest_day
    end
  end
end
