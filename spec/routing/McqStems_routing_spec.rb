require "rails_helper"

RSpec.describe McqStemsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/mcq_stems").to route_to("mcq_stems#index")
    end

    it "routes to #new" do
      expect(:get => "/mcq_stems/new").to route_to("mcq_stems#new")
    end

    it "routes to #show" do
      expect(:get => "/mcq_stems/1").to route_to("mcq_stems#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/mcq_stems/1/edit").to route_to("mcq_stems#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/mcq_stems").to route_to("mcq_stems#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/mcq_stems/1").to route_to("mcq_stems#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/mcq_stems/1").to route_to("mcq_stems#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/mcq_stems/1").to route_to("mcq_stems#destroy", :id => "1")
    end

  end
end
