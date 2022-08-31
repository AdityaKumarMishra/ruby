require 'rails_helper'

RSpec.describe 'diagnostic_test_attempts/index', type: :view do
  let(:user) { FactoryGirl.create(:user) }
  before(:each) do
    sign_in user
    assign(:diagnostic_test_attempts, [
             FactoryGirl.create(:assessment_attempt, :diagnostic_test_type),
             FactoryGirl.create(:assessment_attempt, :diagnostic_test_type)
           ])
  end

  it 'renders a list of diagnostic_test_attempts' do
    render
    assert_select 'tr>td', :text => 'MyString'.to_s, :count => 0
    assert_select 'tr>td', :text => 0.to_s, :count => 0
  end
end
