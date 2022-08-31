require 'rails_helper'

RSpec.describe PodcastsController, type: :controller do
  login_student

  let!(:podcasts) do
    (1..10).to_a.map do |num|
      Podcast.create!(title: 'Podcast' + num.to_s)
    end
  end

  describe "GET #index" do
    it "returns all podcasts" do
      get :index
      expect(assigns(:podcasts).pluck(:id).sort).to eq(podcasts.pluck(:id).sort)
    end
  end

  describe "GET #show" do
    it "returns the podcast" do
      get :show, params: { id: 'podcast10' }
      expect(response).to have_http_status(200)
      expect(assigns(:podcast)).to eq(podcasts.last)
    end
  end
end
