require "rails_helper"

RSpec.describe MarksController, type: :routing do
  xdescribe "routing" do

    it "routes to #index" do
      expect(:get => "/marks").to route_to("marks#index")
    end

    it "routes to #new" do
      expect(:get => "/marks/new").to route_to("marks#new")
    end

    it "routes to #show" do
      expect(:get => "/marks/1").to route_to("marks#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/marks/1/edit").to route_to("marks#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/marks").to route_to("marks#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/marks/1").to route_to("marks#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/marks/1").to route_to("marks#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/marks/1").to route_to("marks#destroy", :id => "1")
    end

  end
end
