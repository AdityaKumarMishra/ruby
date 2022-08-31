require 'rails_helper'

RSpec.describe 'tags/index', type: :view do
  login_superadmin
  before(:each) do
    assign(:tags, [
      Tag.create!(
        name: 'Name 1',
        description: 'MyText 1',
        tagging_count: 1
      ),
      Tag.create!(
        name: 'Name 2',
        description: 'MyText 2',
        tagging_count: 1
      )
    ])
  end

  xit 'renders a list of tags' do
    render
    expect(rendered).to have_content 'Name 1'
    expect(rendered).to have_content 'Name 2'
    expect(rendered).to have_content 'MyText 1'
    expect(rendered).to have_content 'MyText 2'
  end
end
