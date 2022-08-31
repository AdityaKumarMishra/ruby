require 'rails_helper'

RSpec.xdescribe "essays/show", type: :view do
  before(:each) do
    @essay = assign(:essay, Essay.create!(
      :title => "Title",
      :question => "MyText",
      :tutor => FactoryGirl.create(:user, :tutor),
      :student => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
