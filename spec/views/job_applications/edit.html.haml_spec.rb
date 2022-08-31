require 'rails_helper'

RSpec.xdescribe "job_applications/edit", type: :view do
  before(:each) do

    @job_application = assign(:job_application, JobApplication.create!(
        :first_name => "MyString",
        :last_name => "MyString",
        :phone_number => "MyString",
        :email => "MyString",
        :job_application_form_id => 1,
        :resume_file_name => 'test.pdf',
        :resume_content_type => 'application/pdf',
        :resume_file_size => 1024,
        :cover_letter_file_name => 'test.pdf',
        :cover_letter_content_type => 'application/pdf',
        :cover_letter_file_size => 1024
    ))

  end

  it "renders the edit job_application form" do
    render job_application_form_job_application_path(id: @job_application.id, job_application_form_id: 1)

    assert_select "form[action=?][method=?]", job_application_path(@job_application), "post" do

      assert_select "input#job_application_first_name[name=?]", "job_application[first_name]"

      assert_select "input#job_application_last_name[name=?]", "job_application[last_name]"

      assert_select "input#job_application_phone_number[name=?]", "job_application[phone_number]"

      assert_select "input#job_application_email[name=?]", "job_application[email]"

      assert_select "input#job_application_job_application_form_id[name=?]", "job_application[job_application_form_id]"
    end
  end
end
