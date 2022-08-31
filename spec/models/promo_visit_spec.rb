require 'rails_helper'

RSpec.describe PromoVisit, type: :model do
  describe '.visit_count_previous_week' do
    subject { PromoVisit.visit_count_previous_week }

    before(:each) do
      FactoryGirl.create :promo_visit, :current_week
    end

    context 'one click' do
      before(:each) do
        FactoryGirl.create :promo_visit, :previous_week
      end

      it { is_expected.to eq 1 }
    end

    context 'no clicks' do
      it { is_expected.to eq 0 }
    end
  end

  describe '.visit_count_this_week' do
    subject { PromoVisit.visit_count_this_week }

    before(:each) do
      FactoryGirl.create :promo_visit, :previous_week
    end

    context 'one click' do
      before(:each) do
        FactoryGirl.create :promo_visit, :current_week
      end

      it { is_expected.to eq 1 }
    end

    context 'no clicks' do
      it { is_expected.to eq 0 }
    end
  end
end
