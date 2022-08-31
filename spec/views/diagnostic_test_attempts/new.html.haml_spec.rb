require 'rails_helper'

RSpec.describe 'diagnostic_test_attempts/new', type: :view do
  before(:each) do
    assign(:diagnostic_test_attempt, AssessmentAttempt.new(
                                       assessable: FactoryGirl.create(:diagnostic_test)))
    allow(view).to receive(:policy_scope).and_return(Pundit.policy_scope(FactoryGirl.create(:user), AssessmentAttempt))
  end

  it 'renders new diagnostic_test_attempt form' do
    render
    assert_select 'form[action=?][method=?]', diagnostic_test_attempts_path, 'post' do
      assert_select 'select#assessment_attempt_assessable_id[name=?]', 'assessment_attempt[assessable_id]'
    end
  end
end
