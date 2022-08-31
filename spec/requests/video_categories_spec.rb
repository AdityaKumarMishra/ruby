require 'rails_helper'

RSpec.describe "VideoCategories", type: :request do
  describe "GET /video_categories" do
    it "works! (now write some real specs)" do
      get video_categories_path
      expect(response).to have_http_status(200)
    end
  end
end
