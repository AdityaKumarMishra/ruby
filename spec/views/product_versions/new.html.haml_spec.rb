require 'rails_helper'

RSpec.describe "product_versions/new", type: :view do
  before(:each) do
    assign(:product_version, ProductVersion.new(
      :name => "MyString",
      :price => 1.5,
      :type => ""
    ))
    FactoryGirl.create(:master_feature)
    FactoryGirl.create(:tag, id:246)
    FactoryGirl.create(:tag, id:30)
    FactoryGirl.create(:tag, id:38)
    FactoryGirl.create(:tag, id:37)
    @master_features = MasterFeature.all
    @product_line = FactoryGirl.create(:product_line)
  end

  xit "renders new product_version form" do
    render

    assert_select "form[action=?][method=?]", product_versions_path, "post" do

      assert_select "input#product_version_name[name=?]", "product_version[name]"

      assert_select "input#product_version_price[name=?]", "product_version[price]"

      assert_select "input#product_version_type[name=?]", "product_version[type]"
    end
  end
end
