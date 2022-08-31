require "rails_helper"

RSpec.describe StudentClassSessionsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/student_class_sessions").to route_to("student_class_sessions#index")
    end

    it "routes to #new" do
      expect(:get => "/student_class_sessions/new").to route_to("student_class_sessions#new")
    end

    it "routes to #show" do
      expect(:get => "/student_class_sessions/1").to route_to("student_class_sessions#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/student_class_sessions/1/edit").to route_to("student_class_sessions#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/student_class_sessions").to route_to("student_class_sessions#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/student_class_sessions/1").to route_to("student_class_sessions#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/student_class_sessions/1").to route_to("student_class_sessions#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/student_class_sessions/1").to route_to("student_class_sessions#destroy", :id => "1")
    end

  end
end
