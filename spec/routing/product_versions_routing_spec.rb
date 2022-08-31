require "rails_helper"

RSpec.describe ProductVersionsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/product_versions").to route_to("product_versions#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/product_versions/new").to route_to("product_versions#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/product_versions/1").to route_to("product_versions#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/product_versions/1/edit").to route_to("product_versions#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/product_versions").to route_to("product_versions#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/product_versions/1").to route_to("product_versions#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/product_versions/1").to route_to("product_versions#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/product_versions/1").to route_to("product_versions#destroy", :id => "1")
    end

  end
end
