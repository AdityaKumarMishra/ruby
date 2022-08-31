require 'rails_helper'

RSpec.describe "pages/partial/_announcement.haml", type: :view do
  before(:each) do
    @announcement = assign(:announcement, Announcement.create!(
        name: 'GamsatReady',
        description: 'test',
        url: 'www.google.com',
        category: "Homepage"
    ))
    @announcement_url = 'https://' + @announcement.url
  end

  it "renders announcement with url" do
    render 'pages/partial/announcement', product_line: 'gamsat', relative: false
      rendered.should have_selector('a[href="https://www.google.com"]')
  end
end
