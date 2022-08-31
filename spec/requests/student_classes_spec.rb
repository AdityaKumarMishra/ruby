require 'rails_helper'

RSpec.describe "StudentClasses", type: :request do
  describe "GET /student_classes" do
    it "works! (now write some real specs)" do
      get student_classes_path
      expect(response).to have_http_status(200)
    end
  end
end
