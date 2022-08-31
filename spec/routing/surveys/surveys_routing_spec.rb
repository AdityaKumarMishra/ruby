require "rails_helper"

RSpec.describe Surveys::SurveysController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/surveys/surveys").to route_to("surveys/surveys#index")
    end

    it "routes to #new" do
      expect(:get => "/surveys/surveys/new").to route_to("surveys/surveys#new")
    end

    it "routes to #show" do
      expect(:get => "/surveys/surveys/1").to route_to("surveys/surveys#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/surveys/surveys/1/edit").to route_to("surveys/surveys#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/surveys/surveys").to route_to("surveys/surveys#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/surveys/surveys/1").to route_to("surveys/surveys#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/surveys/surveys/1").to route_to("surveys/surveys#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/surveys/surveys/1").to route_to("surveys/surveys#destroy", :id => "1")
    end

  end
end
