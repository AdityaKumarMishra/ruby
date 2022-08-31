require "rails_helper"
RSpec.describe UserMailer, type: :mailer do
  let!(:user) { FactoryGirl.create(:user, :student) }

  describe "send_first_welcome_email" do
    it "sends email after user create" do
      UserMailer.send_first_welcome_email(user).deliver_later
    end
  end

  describe "feature_auto_email" do
    let(:user) { FactoryGirl.create(:user, :student, first_enrolment_date: Date.today - 7.days) }
    it "sends mail for features description" do
      UserMailer.feature_auto_email(user).deliver_later
    end
  end
end
