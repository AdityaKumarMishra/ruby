require 'rails_helper'

RSpec.describe 'Sections', type: :request do
  include RequestSpecHelper
  let(:superadmin) { FactoryGirl.create(:user, :superadmin) }
  before(:each) do
    login(superadmin)
  end
  let(:online_exam) { FactoryGirl.create :online_exam }
  let(:diagnostic_test) { FactoryGirl.create :diagnostic_test }
  let!(:section1) { FactoryGirl.create(:section, sectionable: online_exam) }
  let!(:section2) { FactoryGirl.create(:section, sectionable: diagnostic_test) }
  describe 'GET /online_exam/:online_exam_id/sections' do
    it 'works! (now write some real specs)' do
      get online_exam_sections_path(online_exam)
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /diagnostic_test/:diagnostic_test_id/sections' do
    it 'works!' do
      get diagnostic_test_sections_path(diagnostic_test)
      expect(response).to have_http_status(200)
    end
  end
end
