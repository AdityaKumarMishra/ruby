require 'rails_helper'

RSpec.describe "product_versions/show", type: :view do
  before(:each) do
    @product_version = assign(:product_version, ProductVersion.create!(
      :name => "Name",
      :price => 1.5,
      :type => "GamsatReady",
      :course_type => 0
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to have_content 'Name'
  end
end
