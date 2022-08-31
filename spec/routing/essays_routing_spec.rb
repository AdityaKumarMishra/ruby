require "rails_helper"

RSpec.describe EssaysController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/essays").to route_to("essays#index")
    end

    it "routes to #new" do
      expect(:get => "/essays/new").to route_to("essays#new")
    end

    it "routes to #show" do
      expect(:get => "/essays/1").to route_to("essays#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/essays/1/edit").to route_to("essays#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/essays").to route_to("essays#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/essays/1").to route_to("essays#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/essays/1").to route_to("essays#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/essays/1").to route_to("essays#destroy", :id => "1")
    end

  end
end
