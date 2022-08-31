require 'rails_helper'

RSpec.describe "student_classes/show", type: :view do
  before(:each) do
    @student_class = assign(:student_class, StudentClass.create!(
      :name => "Name",
      :size => 1,
      :subject => FactoryGirl.create(:subject)
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(//)
  end
end
