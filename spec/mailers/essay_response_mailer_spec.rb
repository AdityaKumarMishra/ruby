require "rails_helper"

RSpec.describe EssayResponseMailer, type: :mailer do

  let(:essay_response) {
    FactoryGirl.create :essay_response, user_id: FactoryGirl.create(:user).id, course_id: FactoryGirl.create(:course).id, expiry_date: Date.today
  }

  describe "#expiry_reminder" do
    it "send mail to student for reminding essay expiry" do
      EssayResponseMailer.expiry_reminder(essay_response).deliver_later
    end
  end
end
