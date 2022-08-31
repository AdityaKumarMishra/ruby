require 'rails_helper'

RSpec.describe 'online_exam_attempts/new', type: :view do
  before(:each) do
    assign(:online_exam_attempt, AssessmentAttempt.new(assessable: FactoryGirl.create(:online_exam, :published_with_sections)))
    allow(view).to receive(:policy_scope).and_return(Pundit.policy_scope(FactoryGirl.create(:user), AssessmentAttempt))
  end

  it 'renders new online_exam_attempt form' do
    render
    assert_select 'form[action=?][method=?]', online_exam_attempts_path, 'post' do
      assert_select 'select#assessment_attempt_assessable_id[name=?]', 'assessment_attempt[assessable_id]'
    end
  end
end
