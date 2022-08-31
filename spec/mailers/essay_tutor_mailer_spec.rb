require "rails_helper"
RSpec.describe EssayTutorMailer, type: :mailer do

  let!(:essay) { FactoryGirl.create :essay, title: 'test' }
  let!(:essay_response) { FactoryGirl.create :essay_response, essay_id: essay.id }
  let!(:staff_profile) { FactoryGirl.create :staff_profile }
  let!(:essay_tutor_response) do
    FactoryGirl.create :essay_tutor_response, rating: 20, response: "OKAY", essay_response: essay_response,
                                              created_at: '2016-08-16', staff_profile_id: staff_profile.id
  end
  let!(:user) { FactoryGirl.create(:user, :student) }
  let!(:essay_tutor_feedback) { FactoryGirl.create(:essay_tutor_feedback, user: user, essay_response: essay_response) }

  let(:comment) { FactoryGirl.create(:comment, commentable_type: "EssayTutorFeedback", commentable: essay_tutor_feedback) }


  describe "#feedback_comment_by_tutor" do
    it "sends email to student" do
      EssayTutorMailer.feedback_comment_by_tutor(comment).deliver_later
    end
  end
end
