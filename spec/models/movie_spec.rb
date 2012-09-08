require 'spec_helper'

describe Movie do
  it { should have_many :showtimes }
  it { should have_many(:theaters).through(:showtimes) }

  describe "validations" do
    it { should validate_presence_of :cs_id }
    it { should validate_presence_of :title }

    it { should validate_numericality_of(:cs_id).only_integer }
  end

  describe 'instance methods' do
    before do
      @date = Date.new( 2012, 7, 5 )
      @datetime = DateTime.new( 2012, 7, 5, 15, 30, 0, '-5' )

      release_dates = {
        @date => 'Nationwide',
        @date.yesterday => 'NY'
      }

      @movie = FactoryGirl.create :movie, :release_dates => release_dates

      @theater_1 = FactoryGirl.create :theater, :name => 'ABC Theater'
      @theater_2 = FactoryGirl.create :theater, :name => 'XYZ Theater'

      FactoryGirl.create( :showtime, :movie => @movie, :theater => @theater_1,
                          :playing_on => @date, :playing_at => @datetime )

      FactoryGirl.create( :showtime, :movie => @movie, :theater => @theater_1,
                          :playing_on => @date, :playing_at => @datetime + 2.hours )

      FactoryGirl.create( :showtime, :movie => @movie, :theater => @theater_2,
                          :playing_on => @date, :playing_at => @datetime )

      FactoryGirl.create( :showtime, :movie => @movie, :theater => @theater_2,
                          :playing_on => @date, :playing_at => @datetime + 3.hours )

      FactoryGirl.create( :showtime, :movie => @movie, :theater => @theater_2,
                          :playing_on => @date + 1.day, :playing_at => @datetime + 1.day )
    end

    it 'should return a release date if a movie is newly playing on a given date' do
      DateTime.stub(:now).and_return( @datetime )
      @movie.newly_playing_showtime_on( @date - 1.day ).should == nil
      @movie.newly_playing_showtime_on( @date ).should == @date
      @movie.newly_playing_showtime_on( @date + 8.days ).should == nil
    end

    it 'should return a sorted list of theaters with showtimes for a given date' do
      @movie.theaters_showing_on( @date ).should == [@theater_1, @theater_2]
    end

    it 'should determine if a movie has showtimes remaining today' do
      DateTime.stub(:now).and_return( @datetime )
      @movie.showtimes_remaining_today?.should == true

      DateTime.stub(:now).and_return( @datetime + 6.hours )
      @movie.showtimes_remaining_today?.should == false
    end

    it 'should determine if a movie has showtimes remaining at all' do
      DateTime.stub(:now).and_return( @datetime )
      @movie.showtimes_remaining?.should == true

      DateTime.stub(:now).and_return( @datetime + 2.days )
      @movie.showtimes_remaining?.should == false
    end
  end
end
