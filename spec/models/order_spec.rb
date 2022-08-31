require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:promo) { FactoryGirl.create(:promo, :tokened) }

  context 'contains more than minimum spend' do
    let(:order) { FactoryGirl.create(:order, :ongoing, :with_minimum_spend,reference_number: "gdhsgh7jjhbj") }

    it 'adds promo' do
      promo.generate_token!

      expect {
        order.add_promo promo.token
      }.to change { order.promos.count }.by(1)
    end

    it 'does not double up codes' do
      promo.generate_token!

      expect {
        order.add_promo promo.token
        order.add_promo promo.token
      }.to change { order.promos.count }.by(1)
    end

    it 'does not exceeds used times limit' do
      promo= FactoryGirl.create(:promo, :tokened, used_times: 1)
      promo.generate_token!

      order.user = FactoryGirl.create(:user, :student)
      order.add_promo promo.token
      order.paid!

      expect {
        order.add_promo promo.token
        order.add_promo promo.token
      }.to change { order.promos.count }.by(0)
    end

    it 'does not allow mixing stackable promos' do
      unstackable_promo = promo

      stackable_promo = FactoryGirl.build(:promo, :stackable)
      stackable_promo.generate_token!
      stackable_promo.save!

      order.add_promo unstackable_promo.token
      success = order.add_promo(stackable_promo.token)

      expect(success).to eq(false)
    end

    it 'creates a promo after transaction' do
      order.user = FactoryGirl.create(:user, :student)
      order.add_promo promo.token
      order.paid!

      expect {
        order.update_promo!
      }.to change(Promo, :count).by(1)
    end
  end

  context 'contains less than minimum spend' do
    let(:order) { FactoryGirl.create(:order, :ongoing) }
    xit 'wont add promo' do
      promo.generate_token!

      expect {
        order.add_promo promo.token
      }.not_to change { order.promos.count }
    end

    it 'creates a promo after transaction' do
      order.user = FactoryGirl.create(:user, :student)
      order.add_promo promo.token
      order.paid!

      expect {
        order.update_promo!
      }.to change(Promo, :count).by(1)
    end
  end

  describe '#can_checkout?' do
    let(:order) { FactoryGirl.create(:order, :ongoing) }

    it { expect { order.can_checkout? }.not_to raise_error }
  end

  describe '#with_purchase' do
    let(:order) { FactoryGirl.create(:order, reference_number: 'y9tueo') }
    let(:orders) { Order.where(reference_number: 'y9tueo') }
    let(:results) { Order.with_purchase(order) }
    it 'should return orders' do
      expect(results).to match_array(orders)
    end
  end
end
