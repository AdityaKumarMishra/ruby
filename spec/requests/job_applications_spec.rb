require 'rails_helper'

RSpec.describe "JobApplications", type: :request do
  describe "GET /job_application_forms/:id/job_applications" do
    let(:job_application_form) { FactoryGirl.create :job_application_form }

    it "works! (now write some real specs)" do
      get job_application_form_job_applications_path(job_application_form)
      expect(response).to have_http_status(302)
    end
  end
end