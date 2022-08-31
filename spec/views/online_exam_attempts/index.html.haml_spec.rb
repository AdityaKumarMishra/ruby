require 'rails_helper'

RSpec.describe 'online_exam_attempts/index', type: :view do
  let(:user) { FactoryGirl.create(:user) }
  let!(:oxa1) { FactoryGirl.create(:assessment_attempt, :online_exam_type) }
  let!(:oxa2) { FactoryGirl.create(:assessment_attempt, :online_exam_type) }
  before(:each) do
    sign_in user
    assign(:online_exam_attempts, AssessmentAttempt.all)
  end

  it 'renders a list of online_exam_attempts' do
    render
    assert_select 'tr>td', :text => 'MyString'.to_s, :count => AssessmentAttempt.count
    assert_select 'tr>td', :text => 2.to_s, :count => AssessmentAttempt.count
  end
end
