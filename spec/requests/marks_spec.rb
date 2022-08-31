require 'rails_helper'

RSpec.xdescribe "Marks", type: :request do
  describe "GET /marks" do
    it "works! (now write some real specs)" do
      get marks_path
      expect(response).to have_http_status(200)
    end
  end
end
