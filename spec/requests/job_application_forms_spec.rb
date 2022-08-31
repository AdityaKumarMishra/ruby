require 'rails_helper'

RSpec.describe "JobApplicationForms", type: :request do
  describe "GET /job_application_forms" do
    it "works! (now write some real specs)" do
      get job_application_forms_path
      expect(response).to have_http_status(302)
    end
  end
end
