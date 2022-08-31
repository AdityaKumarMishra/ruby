require 'rails_helper'

RSpec.describe "TutorAvailabilities", type: :request do
  describe "GET /tutor_availabilities" do
    it "works! (now write some real specs)" do
      get tutor_availabilities_path
      expect(response).to have_http_status(302)
    end
  end
end
