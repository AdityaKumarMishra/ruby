require 'rails_helper'

RSpec.describe 'enrolments/new', type: :view do
  before(:each) do
    @student = assign(:student, FactoryGirl.create(:user))
    assign(:enrolment, Enrolment.new)
  end

  it 'renders new enrolment form' do
    render

    assert_select 'form[action=?][method=?]', user_enrolments_path(@student), 'post'
  end
end
