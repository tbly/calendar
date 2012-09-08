require 'spec_helper'

describe Theater do
  describe subject do
    it { should have_many(:showtimes) }

    describe 'validations' do
      it { should validate_presence_of(:cs_id) }
      it { should validate_presence_of(:name) }
      it { should validate_presence_of(:address) }
      it { should validate_presence_of(:city) }
      it { should validate_presence_of(:state) }
      it { should validate_presence_of(:zip) }
      it { should validate_presence_of(:phone) }
      it { should validate_presence_of(:county) }

      it { should validate_numericality_of(:cs_id).only_integer }
      it { should validate_numericality_of(:screens).only_integer }
    end
  end
end
