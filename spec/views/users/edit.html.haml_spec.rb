require 'rails_helper'

RSpec.describe "users/edit.html.haml", type: :view do
  before { sign_in FactoryGirl.create :user, :superadmin }
  let(:user) { FactoryGirl.create :user }

  it "should render without errors" do
    @user = user
    expect { render }.not_to raise_error
    expect(render).to match(/New Enrolment/)
  end
end
