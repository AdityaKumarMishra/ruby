require 'rails_helper'

RSpec.describe "job_applications/index", type: :view do
  before(:each) do
    @job_application_form = FactoryGirl.create :job_application_form

    ja1 = FactoryGirl.create :job_application
    ja1.job_application_form = @job_application_form
    ja2 = FactoryGirl.create :job_application
    ja2.job_application_form = @job_application_form
    assign(:job_applications, [ja1, ja2])

  end

  xit "renders a list of job_applications" do
    render
    assert_select "tr>td", :text => "John Doe".to_s, :count => 2
    assert_select "tr>td", :text => "201612".to_s, :count => 2
    assert_select "tr>td", :text => "PhD".to_s, :count => 2
  end
end
