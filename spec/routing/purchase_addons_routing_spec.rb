require "rails_helper"

RSpec.describe PurchaseAddonsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/purchase_addons").to route_to("purchase_addons#index")
    end

    it "routes to #new" do
      expect(:get => "/purchase_addons/new").to route_to("purchase_addons#new")
    end

    it "routes to #show" do
      expect(:get => "/purchase_addons/1").to route_to("purchase_addons#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/purchase_addons/1/edit").to route_to("purchase_addons#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/purchase_addons").to route_to("purchase_addons#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/purchase_addons/1").to route_to("purchase_addons#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/purchase_addons/1").to route_to("purchase_addons#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/purchase_addons/1").to route_to("purchase_addons#destroy", :id => "1")
    end

  end
end
