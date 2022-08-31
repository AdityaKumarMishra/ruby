require "rails_helper"

RSpec.describe JobApplicationsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/jobs/1/job-applications").to route_to("job_applications#index", job_application_form_id: '1')
    end

    it "routes to #new" do
      expect(:get => "/jobs/1/job-applications/new").to route_to("job_applications#new", job_application_form_id: '1')
    end

    it "routes to #show" do
      expect(:get => "/jobs/1/job-applications/1").to route_to("job_applications#show", :id => "1", job_application_form_id: '1')
    end

    it "routes to #edit" do
      expect(:get => "/jobs/1/job-applications/1/edit").to route_to("job_applications#edit", :id => "1", job_application_form_id: '1')
    end

    it "routes to #create" do
      expect(:post => "/jobs/1/job-applications").to route_to("job_applications#create", job_application_form_id: '1')
    end

    it "routes to #update via PUT" do
      expect(:put => "/jobs/1/job-applications/1").to route_to("job_applications#update", :id => "1", job_application_form_id: '1')
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/jobs/1/job-applications/1").to route_to("job_applications#update", :id => "1", job_application_form_id: '1')
    end

    it "routes to #destroy" do
      expect(:delete => "/jobs/1/job-applications/1").to route_to("job_applications#destroy", :id => "1", job_application_form_id: '1')
    end

  end
end
