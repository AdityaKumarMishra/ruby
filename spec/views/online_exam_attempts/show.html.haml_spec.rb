require 'rails_helper'

RSpec.describe 'online_exam_attempts/show', type: :view do
  before(:each) do
    @online_exam_attempt = assign(:online_exam_attempt, FactoryGirl.create(:assessment_attempt, :online_exam_type))
  end

  xit 'renders attributes in <p>' do
    render
    expect(rendered).to match(/MyString/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/2/)
  end
end
