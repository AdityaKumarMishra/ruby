require 'rails_helper'

RSpec.describe "video_categories/new", type: :view do
  before(:each) do
    assign(:video_category, VideoCategory.new(
      :name => "MyString",
      :subject => FactoryGirl.create(:subject)
    ))
  end

  it "renders new video_category form" do
    render

    assert_select "form[action=?][method=?]", video_categories_path, "post" do

      assert_select "input#video_category_name[name=?]", "video_category[name]"

      assert_select "select#video_category_subject_id[name=?]", "video_category[subject_id]"
    end
  end
end
