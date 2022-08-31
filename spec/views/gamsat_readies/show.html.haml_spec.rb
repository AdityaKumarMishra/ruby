require 'rails_helper'

RSpec.describe "gamsat_readies/show", type: :view do
  before(:each) do
    @product_version = assign(:product_version, ProductVersion.create!(
      slug: FFaker::Internet.slug,
      name: "MyString",
      price: 200,
      type: "GamsatReady",
      description: "amazing description",
      course_type: 4
    ))
  end

  xit "renders attributes in <p>" do
    controller.request.env['PATH_INFO'] = 'gamsat/online'
    render
    rendered.should_not match('Helped over 1000 students prepare for the 2016 March GAMSAT')
  end
end
