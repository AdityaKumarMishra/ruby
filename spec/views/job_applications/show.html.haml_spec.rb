require 'rails_helper'

RSpec.xdescribe "job_applications/show", type: :view do
  before(:each) do
    @job_application_form = FactoryGirl.create :job_application_form

    @job_application = FactoryGirl.create :job_application
    @job_application.job_application_form = @job_application_form
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/John/)
    expect(rendered).to match(/Doe/)
    expect(rendered).to match(/1234/)
    expect(rendered).to match(/test/)
    it { should have_select('#status') }
  end
end