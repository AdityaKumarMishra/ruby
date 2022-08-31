require 'rails_helper'

RSpec.describe "product_versions/edit", type: :view do
  before(:each) do
    @product_version = assign(:product_version, ProductVersion.create!(
      :name => "MyString",
      :price => 1.5,
      :type => "",
      :course_type => 0
    ))
    FactoryGirl.create(:master_feature)
    FactoryGirl.create(:tag, id:246)
    FactoryGirl.create(:tag, id:30)
    FactoryGirl.create(:tag, id:38)
    FactoryGirl.create(:tag, id:37)
    @master_features = MasterFeature.all
    @product_line = FactoryGirl.create(:product_line)
  end

  it "renders the edit product_version form" do
    render

    assert_select "form[action=?][method=?]", product_version_path(@product_version), "post" do

      assert_select "input#product_version_name[name=?]", "product_version[name]"

      assert_select "input#product_version_price[name=?]", "product_version[price]"

      assert_select "input#product_version_type[name=?]", "product_version[type]"
    end
  end
end
