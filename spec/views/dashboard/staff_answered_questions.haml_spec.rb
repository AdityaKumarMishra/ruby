require 'rails_helper'

RSpec.describe 'dashboard/staff_answered_questions', type: :view do
  let(:tutor1) { FactoryGirl.create :user, :tutor, first_name: "John" }
  let(:tutor2) { FactoryGirl.create :user, :tutor, first_name: "Tom" }
  before(:each) do
    assign(:tutors, [tutor1, tutor2])
  end

  it 'renders a list of tutors' do
    expect { view }.not_to raise_error
  end
end

