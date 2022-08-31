require 'rails_helper'

RSpec.describe 'enrolments/edit', type: :view do
  before { sign_in FactoryGirl.create :user, :superadmin }
  before(:each) do
    @student = assign(:student, FactoryGirl.create(:user))
    @enrolment = assign(:enrolment, FactoryGirl.create(:enrolment))
  end

  it 'renders the edit enrolment form' do
    render

    assert_select 'form[action=?][method=?]', user_enrolment_path(@student, @enrolment), 'post'
  end
end
