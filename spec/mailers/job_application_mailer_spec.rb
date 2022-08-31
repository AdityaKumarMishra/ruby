require "rails_helper"

RSpec.describe JobApplicationMailer, type: :model do

  let(:job_application_form) { FactoryGirl.create :job_application_form }
  let(:job_application1) { FactoryGirl.create :job_application, status: "3.1 Successful Interview", job_application_form_id: job_application_form.id, applicant_type: "Current University Student" }
  let(:job_application2) { FactoryGirl.create :job_application, status: "3.2 Unsuccessful Interview", job_application_form_id: job_application_form.id, applicant_type: "Current University Student" }
  describe "#successful_job_application" do
    it "sends mail for successful job application" do
      JobApplicationMailer.successful_job_application(job_application1).deliver_later
    end
  end
  describe "#unsuccessful_job_application" do
    it "sends mail for unsuccessful job application" do
      JobApplicationMailer.unsuccessful_job_application(job_application2).deliver_later
    end
  end
  describe "#student_job_application" do
    it "sends mail to manager for when student submit job application" do
      JobApplicationMailer.student_job_application(job_application1).deliver_later
    end
  end

end
