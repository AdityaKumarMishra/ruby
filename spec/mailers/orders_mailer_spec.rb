require "rails_helper"

RSpec.describe OrdersMailer, type: :mailer do

  let(:order) {
    FactoryGirl.create :order, user_id: FactoryGirl.create(:user).id, generated_promo: FactoryGirl.create(:promo, token: 'SAMPLE10')
  }

  describe ".promo_shared" do
    it "sends email to email list" do
      emails = "ts-at@gradready.com.au, ts-tt@gradready.com.au"
      OrdersMailer.promo_shared(emails, order).deliver_later
    end
  end

  describe "#unsuccessful_purchase" do
    it "sends email to gradready payment email" do
      email = "payment@gradready.com.au"
      OrdersMailer.unsuccessful_purchase(order).deliver_later
    end
  end
end
