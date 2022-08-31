require 'rails_helper'

RSpec.xdescribe "Featurettes", type: :request do
  describe "GET /featurettes" do
    it "works! (now write some real specs)" do
      get featurettes_path
      expect(response).to have_http_status(200)
    end
  end
end
