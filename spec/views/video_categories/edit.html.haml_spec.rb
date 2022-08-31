require 'rails_helper'

RSpec.describe "video_categories/edit", type: :view do
  before(:each) do
    @video_category = assign(:video_category, VideoCategory.create!(
      :name => "MyString",
      :subject => FactoryGirl.create(:subject)
    ))
  end

  it "renders the edit video_category form" do
    render

    assert_select "form[action=?][method=?]", video_category_path(@video_category), "post" do

      assert_select "input#video_category_name[name=?]", "video_category[name]"

      assert_select "select#video_category_subject_id[name=?]", "video_category[subject_id]"
    end
  end
end
