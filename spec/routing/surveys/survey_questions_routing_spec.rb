require "rails_helper"

RSpec.describe Surveys::SurveyQuestionsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/surveys/survey_questions").to route_to("surveys/survey_questions#index")
    end

    it "routes to #new" do
      expect(:get => "/surveys/survey_questions/new").to route_to("surveys/survey_questions#new")
    end

    it "routes to #show" do
      expect(:get => "/surveys/survey_questions/1").to route_to("surveys/survey_questions#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/surveys/survey_questions/1/edit").to route_to("surveys/survey_questions#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/surveys/survey_questions").to route_to("surveys/survey_questions#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/surveys/survey_questions/1").to route_to("surveys/survey_questions#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/surveys/survey_questions/1").to route_to("surveys/survey_questions#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/surveys/survey_questions/1").to route_to("surveys/survey_questions#destroy", :id => "1")
    end

  end
end
