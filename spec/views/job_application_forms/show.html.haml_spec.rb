require 'rails_helper'

RSpec.describe "job_application_forms/show", type: :view do
  before(:each) do
    @job_application_form = assign(:job_application_form, JobApplicationForm.create!(
      title: "Title",
      description: "MyText",
      open: true
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/true/)
  end
end
