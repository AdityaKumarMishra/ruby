require "rails_helper"

RSpec.describe TutorSchedulesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/tutor_schedules").to route_to("tutor_schedules#index")
    end

    it "routes to #new" do
      expect(:get => "/tutor_schedules/new").to route_to("tutor_schedules#new")
    end

    it "routes to #show" do
      expect(:get => "/tutor_schedules/1").to route_to("tutor_schedules#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/tutor_schedules/1/edit").to route_to("tutor_schedules#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/tutor_schedules").to route_to("tutor_schedules#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/tutor_schedules/1").to route_to("tutor_schedules#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/tutor_schedules/1").to route_to("tutor_schedules#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/tutor_schedules/1").to route_to("tutor_schedules#destroy", :id => "1")
    end

  end
end
