require 'rails_helper'

RSpec.describe 'diagnostic_test_attempts/show', type: :view do
  before(:each) do
    @diagnostic_test_attempt = assign(:diagnostic_test_attempt, FactoryGirl.create(:assessment_attempt, :diagnostic_test_type))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/MyString/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/1.5/)
  end
end
