require 'rails_helper'

RSpec.describe "job_application_forms/edit", type: :view do
  before(:each) do
    @job_application_form = assign(:job_application_form, JobApplicationForm.create!(
      title: "MyString",
      description: "MyText",
      open: true
    ))
  end

  it "renders the edit job_application_form form" do
    render

    assert_select "form[action=?][method=?]", job_application_form_path(@job_application_form), "post" do

      assert_select "input#job_application_form_title[name=?]", "job_application_form[title]"

      assert_select "textarea#job_application_form_description[name=?]", "job_application_form[description]"
    end
  end
end
