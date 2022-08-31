require "rails_helper"

RSpec.describe StudentClassesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/student_classes").to route_to("student_classes#index")
    end

    it "routes to #new" do
      expect(:get => "/student_classes/new").to route_to("student_classes#new")
    end

    it "routes to #show" do
      expect(:get => "/student_classes/1").to route_to("student_classes#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/student_classes/1/edit").to route_to("student_classes#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/student_classes").to route_to("student_classes#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/student_classes/1").to route_to("student_classes#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/student_classes/1").to route_to("student_classes#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/student_classes/1").to route_to("student_classes#destroy", :id => "1")
    end

  end
end
