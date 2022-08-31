require 'rails_helper'

RSpec.xdescribe "TutorSchedules", type: :request do
  describe "GET /tutor_schedules" do
    it "works! (now write some real specs)" do
      get tutor_schedules_path
      expect(response).to have_http_status(200)
    end
  end
end
