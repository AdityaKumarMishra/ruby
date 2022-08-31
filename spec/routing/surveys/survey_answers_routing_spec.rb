require "rails_helper"

RSpec.describe Surveys::SurveyAnswersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/surveys/survey_answers").to route_to("surveys/survey_answers#index")
    end

    it "routes to #new" do
      expect(:get => "/surveys/survey_answers/new").to route_to("surveys/survey_answers#new")
    end

    it "routes to #show" do
      expect(:get => "/surveys/survey_answers/1").to route_to("surveys/survey_answers#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/surveys/survey_answers/1/edit").to route_to("surveys/survey_answers#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/surveys/survey_answers").to route_to("surveys/survey_answers#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/surveys/survey_answers/1").to route_to("surveys/survey_answers#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/surveys/survey_answers/1").to route_to("surveys/survey_answers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/surveys/survey_answers/1").to route_to("surveys/survey_answers#destroy", :id => "1")
    end

  end
end
