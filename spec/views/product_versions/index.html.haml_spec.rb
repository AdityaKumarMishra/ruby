require 'rails_helper'

RSpec.describe "product_versions/index", type: :view do
  before(:each) do
    assign(:product_versions, [
      ProductVersion.create(
        :id => 1,
        :name => "Name 1",
        :price => 1.5,
        :type => "GamsatReady"
      ),
      ProductVersion.create(
        :id => 2,
        :name => "Name 2",
        :price => 1.5,
        :type => "UmatReady"
      )
    ])
    assign(:product_version_types, ProductVersion.subclasses.map(&:to_s))
    assign(:total_courses, [
      Course.num_courses_created_by(1),
      Course.num_courses_created_by(2)
      ])
  end

  xit "renders a list of product_versions" do
    render
    expect(rendered).to have_content 'Name 1'
    expect(rendered).to have_content 'Name 2'
    expect(rendered).to have_content 'GamsatReady'
    expect(rendered).to have_content 'UmatReady'
  end
end
