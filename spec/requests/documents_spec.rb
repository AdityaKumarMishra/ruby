require 'rails_helper'

RSpec.describe "Documents", type: :request do
  describe "GET /documents" do
    it "works! (now write some real specs)" do
      get documents_path
      expect(response).to have_http_status(302)
    end
  end
end
