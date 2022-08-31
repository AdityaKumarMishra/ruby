require 'rails_helper'

RSpec.describe Promo, type: :model do
  let(:promo) { FactoryGirl.create(:promo) }

  it 'generates token' do
    promo.generate_token!
    expect(promo.token).not_to be_nil
  end

  it 'upcases token' do
    token = "hElLoWoRlD"
    promo.token = token

    expect(promo.token).to eq token.upcase
  end

  it 'finds by upcase token' do
    promo.generate_token!

    expect(Promo.find_by_token(promo.token.downcase)).to eq(promo)
  end

  xit 'calculates discount' do
    item = FactoryGirl.create(:purchase_item)

    expect { promo.calculate! [ item ] }.to change(item, :discount_applied).from(0).to((item.initial_cost + item.added_gst)*0.5)
  end
end
