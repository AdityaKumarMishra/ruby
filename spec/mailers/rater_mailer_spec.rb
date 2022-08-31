require "rails_helper"

RSpec.describe RaterMailer, type: :mailer do
  let(:user){FactoryGirl.create :user, :student}
  let(:mcq){FactoryGirl.create :mcq}
  let(:rate){FactoryGirl.create :rate, rater_id: user.id, rateable_id: mcq.id, rateable_type: "Mcq", stars: 4}

  describe "#low_rating" do
    it "sends mail to when student low marked the mcq or video" do
      RaterMailer.low_rating(rate).deliver_later
    end
  end

  describe "#rating_feedback" do
  	let!(:order) { FactoryGirl.create(:order, status: :paid, user: user) }
    let!(:enrolment) { FactoryGirl.create(:enrolment) }
    let!(:paid_purchase_item) { FactoryGirl.create(:purchase_item, user: user, order: order, purchasable: enrolment) }
    let!(:course) { enrolment.course }

    it "sends mail to when student low marked the mcq or video" do
      RaterMailer.rating_feedback(rate, user.active_courses.order(:id).first).deliver_later
    end
  end

end
