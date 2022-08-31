require 'rails_helper'

RSpec.describe "job_application_forms/new", type: :view do
  before(:each) do
    assign(:job_application_form, JobApplicationForm.new(
      title: "MyString",
      description: "MyText",
      open: true
    ))
  end

  it "renders new job_application_form form" do
    render

    assert_select "form[action=?][method=?]", job_application_forms_path, "post" do

      assert_select "input#job_application_form_title[name=?]", "job_application_form[title]"

      assert_select "textarea#job_application_form_description[name=?]", "job_application_form[description]"
    end
  end
end
