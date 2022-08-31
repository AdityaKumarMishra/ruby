require 'rails_helper'

RSpec.describe 'tags/show', type: :view do
  before(:each) do
    @tag = assign(:tag, Tag.create!(
                          name: 'Name',
                          description: 'MyText',
                          tagging_count: 1
    ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/User Accounts/)
  end
end
