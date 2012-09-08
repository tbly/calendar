# -*- coding: utf-8 -*-
require 'spec_helper'

describe Blotter::ArrestScraper do
  before :each do
    @arrest_scraper = Blotter::ArrestScraper.new
  end

  it "should initially have default params as Today and no look back" do
    @arrest_scraper.date.should == Date.today
    @arrest_scraper.number_of_days.should == 0
  end

  it "should process with default params as Today and no look back if no arguments passed" do
    @arrest_scraper.process
    @arrest_scraper.date.should == Date.today
    @arrest_scraper.number_of_days.should == 0
  end

  it "should create a single Blotter::ArrestDay object that contains an array of Arrest objects" do
    VCR.use_cassette('get_arrests_from_blotter') do
      arrest_scraper = Blotter::ArrestScraper.new( 0, Date.new(2012, 8, 31) )
      results = arrest_scraper.process

      results.size.should == 1
      first_result = results.first
      first_result.class.should == Blotter::ArrestDay
      first_result.date.should == Date.new(2012,8,31)
      first_result.consume_url.should == 'http://www.iowa-city.org/icgov/apps/police/blotter.asp?date=08312012'
      first_result.arrests.class.should == Array
      first_result.error.should == nil

      first_result.arrests.size.should == 12
      first_result_arrest = first_result.arrests.first

      first_result_arrest.members.should == [:name, :address, :date, :dob, :location, :incident, :ca, :charges, :error]
      first_result_arrest.name.should == 'BEIGHTOL, KATHRYN A'
      first_result_arrest.address.should == '414 CONCORD LANE. NORTH BARRINGTON, IL'
      first_result_arrest.date.should == DateTime.new( 2012, 8, 31, 1, 1 )
      first_result_arrest.dob.should == DateTime.new( 1991, 8, 10 )
      first_result_arrest.location.should == '327 E COLLEGE'
      first_result_arrest.incident.should == '12010368'
      first_result_arrest.ca.should == 'A'
      first_result_arrest.charges.should == '1) Public Intoxication'
    end
  end

  it "should process the arrests for today and n preceding days if provided" do
    VCR.use_cassette('get_arrests_from_blotter_for_previous_days') do
      arrest_scraper = Blotter::ArrestScraper.new( 3 )
      results = arrest_scraper.process
      arrest_scraper.date.should == Date.today
      arrest_scraper.number_of_days.should == 3

      results.size.should == 4
      results[0].date.should == Date.today
      results[1].date.should == Date.today - 1
      results[2].date.should == Date.today - 2
      results[3].date.should == Date.today - 3
    end
  end

  it "should return a single Blotter::ArrestDay object that contains no Arrest objects if not found consumed url" do
    VCR.use_cassette('get_arrests_for_invalid_date') do
      arrest_scraper = Blotter::ArrestScraper.new( 0, Date.new(2013, 8, 31) )
      results = arrest_scraper.process

      results.size.should == 1
      first_result = results.first
      first_result.class.should == Blotter::ArrestDay
      first_result.date.should == Date.new(2013,8,31)
      first_result.consume_url.should == 'http://www.iowa-city.org/icgov/apps/police/blotter.asp?date=08312013'

      first_result.arrests.class.should == Array
      first_result.arrests.size.should == 0
    end
  end

  it "should return a single Blotter::ArrestDay object with error if got HTTPError on consumed url" do
    VCR.use_cassette('get_arrests_from_malformed_url') do
      arrest_scraper = Blotter::ArrestScraper.new( 0, Date.new(2013, 8, 31), 'http://www.iowa-city.org/HTTPError' )
      results = arrest_scraper.process

      results.size.should == 1
      first_result = results.first
      first_result.class.should == Blotter::ArrestDay
      first_result.date.should == Date.new(2013,8,31)
      first_result.consume_url.should == 'http://www.iowa-city.org/HTTPError?date=08312013'
      first_result.error.should == "404 Not Found"
    end
  end
end
