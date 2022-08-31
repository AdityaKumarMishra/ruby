require "rails_helper"

RSpec.describe TutorAvailabilitiesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/tutor_availabilities").to route_to("tutor_availabilities#index")
    end

    it "routes to #new" do
      expect(:get => "/tutor_availabilities/new").to route_to("tutor_availabilities#new")
    end

    it "routes to #show" do
      expect(:get => "/tutor_availabilities/1").to route_to("tutor_availabilities#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/tutor_availabilities/1/edit").to route_to("tutor_availabilities#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/tutor_availabilities").to route_to("tutor_availabilities#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/tutor_availabilities/1").to route_to("tutor_availabilities#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/tutor_availabilities/1").to route_to("tutor_availabilities#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/tutor_availabilities/1").to route_to("tutor_availabilities#destroy", :id => "1")
    end

  end
end
