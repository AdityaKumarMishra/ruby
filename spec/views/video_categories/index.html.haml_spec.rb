require 'rails_helper'

RSpec.describe "video_categories/index", type: :view do
  before(:each) do
    assign(:video_categories, [
      VideoCategory.create!(
        :name => "Name",
        :subject => FactoryGirl.create(:subject)
      ),
      VideoCategory.create!(
        :name => "Name",
        :subject => FactoryGirl.create(:subject)
      )
    ])
  end

  it "renders a list of video_categories" do
    render
    assert_select "tr>td", :text => "Name", :count => 2
    expect(rendered).to have_content(VideoCategory.first.subject)
    expect(rendered).to have_content(VideoCategory.last.subject)
  end
end
