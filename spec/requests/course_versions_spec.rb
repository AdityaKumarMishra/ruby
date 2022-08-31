require 'rails_helper'

xdescribe "CourseVersions", type: :request do
  describe "GET /course_versions" do
    it "works! (now write some real specs)" do
      get course_versions_path
      expect(response).to have_http_status(200)
    end
  end
end
