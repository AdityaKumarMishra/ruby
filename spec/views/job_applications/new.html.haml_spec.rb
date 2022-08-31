require 'rails_helper'

RSpec.describe "job_applications/new", type: :view do
  login_superadmin
  before(:each) do
    @job_application_form = assign(:job_application_form, FactoryGirl.create(:job_application_form))
    assign(:job_application, FactoryGirl.build(:job_application))
  end

  xit "renders new job_application form" do
    render
    assert_select "form[action=?][method=?]", job_application_form_job_applications_path(@job_application_form), "post" do
      assert_select "input#job_application_name[name=?]", "job_application[name]"
      assert_select "input#job_application_phone_number[name=?]", "job_application[phone_number]"
      assert_select "input#job_application_email[name=?]", "job_application[email]"
      assert_select "input#job_application_hours_available[name=?]", "job_application[hours_available]"
      assert_select "select#job_application_degree_type[name=?]", "job_application[degree_type]"
      assert_select "input#job_application_degree[name=?]", "job_application[degree]"
      assert_select "input#job_application_atar[name=?]", "job_application[atar]"
      assert_select "input#job_application_wam[name=?]", "job_application[wam]"
      assert_select "textarea#job_application_address_attributes_line_one[name=?]", "job_application[address_attributes][line_one]"
      assert_select "input#job_application_address_attributes_suburb[name=?]", "job_application[address_attributes][suburb]"
      assert_select "input#job_application_address_attributes_city[name=?]", "job_application[address_attributes][city]"
    end
  end
end
