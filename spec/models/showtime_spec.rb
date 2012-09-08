require 'spec_helper'

describe Showtime do
  describe "validations" do
    it { should belong_to :movie}
    it { should belong_to :theater }

    describe 'validations' do
      it { should validate_presence_of(:movie_id) }
      it { should validate_presence_of(:theater_id) }
      it { should validate_presence_of(:playing_at) }
      it { should validate_presence_of(:playing_on) }
      it { should validate_presence_of(:link) }
    end

    describe 'class methods' do
      before do
        FactoryGirl.create :showtime, :playing_on => Date.new( 2012, 7, 5 )
        FactoryGirl.create :showtime, :playing_on => Date.new( 2012, 7, 5 )
        FactoryGirl.create :showtime, :playing_on => Date.new( 2012, 7, 6 )
        FactoryGirl.create :showtime, :playing_on => Date.new( 2012, 7, 7 )

        @unique_dates = [ Date.new( 2012, 7, 5 ),
                          Date.new( 2012, 7, 6 ),
                          Date.new( 2012, 7, 7 ) ]
      end

      it 'should return a list of unique show dates' do
        Showtime.unique_show_dates.should == @unique_dates
      end

      it 'should return either today or the first unique show date' do
        Date.stub(:today).and_return( Date.new( 2012, 7, 6 )  )
        Showtime.show_date_today_or_first_unique.should == Date.new( 2012, 7, 6 )

        Date.stub(:today).and_return( Date.new( 2012, 8, 18 )  )
        Showtime.show_date_today_or_first_unique.should == Date.new( 2012, 7, 5 )
      end
    end
  end
end
