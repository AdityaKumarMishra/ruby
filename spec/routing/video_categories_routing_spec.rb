require "rails_helper"

RSpec.describe VideoCategoriesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/video_categories").to route_to("video_categories#index")
    end

    it "routes to #new" do
      expect(:get => "/video_categories/new").to route_to("video_categories#new")
    end

    it "routes to #show" do
      expect(:get => "/video_categories/1").to route_to("video_categories#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/video_categories/1/edit").to route_to("video_categories#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/video_categories").to route_to("video_categories#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/video_categories/1").to route_to("video_categories#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/video_categories/1").to route_to("video_categories#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/video_categories/1").to route_to("video_categories#destroy", :id => "1")
    end

  end
end
