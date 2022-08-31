require 'rails_helper'

RSpec.describe EssayTutorFeedback, type: :model do
  let!(:essay) { FactoryGirl.create :essay, title: 'test' }
  let!(:essay_response) { FactoryGirl.create :essay_response, essay_id: essay.id }
  let!(:staff_profile) { FactoryGirl.create :staff_profile }
  let!(:essay_tutor_response1) do
    FactoryGirl.create :essay_tutor_response, rating: 20, response: "OKAY", essay_response: essay_response,
                                              created_at: '2016-08-16', staff_profile_id: staff_profile.id
  end
  let!(:user) { FactoryGirl.create(:user, :student) }
  let!(:essay_tutor_feedback) { FactoryGirl.create(:essay_tutor_feedback, user: user, essay_response: essay_response) }

  it { should have_many(:comments).dependent(:destroy)}

  describe '#check_rating' do
    xit 'Inform tutor if rating if less then equal to 60' do
      tutor = essay_response.essay_tutor_response.staff_profile
      response = essay_tutor_feedback.check_rating
      subject = "Low Tutor feedback - #{tutor.staff.full_name}"
      expect(response.from).to eq(['student.care@gradready.com.au'])
      expect(response.subject).to eq(subject)
    end
  end

  describe '#inform_tutor' do
    xit 'Inform tutor after feedback' do
      user = essay_response.user
      response = essay_tutor_feedback.inform_tutor
      subject = "Feedback from - #{user.full_name}"
      expect(response.from).to eq(['student.care@gradready.com.au'])
      expect(response.subject).to eq(subject)
    end
  end
end
