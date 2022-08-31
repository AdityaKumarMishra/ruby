require "rails_helper"

RSpec.describe CourseVersionsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "courses/1/course_versions").to route_to("course_versions#index", course_id: '1')
    end

    it "routes to #new" do
      expect(:get => "courses/1/course_versions/new").to route_to("course_versions#new", course_id: '1')
    end

    it "routes to #show" do
      expect(:get => "courses/1/course_versions/1").to route_to("course_versions#show", :id => "1", course_id: '1')
    end

    it "routes to #edit" do
      expect(:get => "courses/1/course_versions/1/edit").to route_to("course_versions#edit", :id => "1", course_id: '1')
    end

    it "routes to #create" do
      expect(:post => "courses/1/course_versions").to route_to("course_versions#create", course_id: '1')
    end

    it "routes to #update via PUT" do
      expect(:put => "courses/1/course_versions/1").to route_to("course_versions#update", :id => "1", course_id: '1')
    end

    it "routes to #update via PATCH" do
      expect(:patch => "courses/1/course_versions/1").to route_to("course_versions#update", :id => "1", course_id: '1')
    end

    it "routes to #destroy" do
      expect(:delete => "courses/1/course_versions/1").to route_to("course_versions#destroy", :id => "1", course_id: '1')
    end

  end
end
