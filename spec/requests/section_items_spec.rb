require 'rails_helper'

RSpec.describe 'SectionItems', type: :request do
  include RequestSpecHelper
  let(:superadmin) { FactoryGirl.create(:user, :superadmin) }
  before(:each) do
    login(superadmin)
  end
  let(:online_exam) { FactoryGirl.create :online_exam }
  let(:diagnostic_test) { FactoryGirl.create :diagnostic_test }
  let!(:section1) { FactoryGirl.create(:section, sectionable: online_exam) }
  let!(:section2) { FactoryGirl.create(:section, sectionable: diagnostic_test) }

  describe 'GET /online_exam/:online_exam_id/sections/:section_id/section_items' do
    it 'works! (now write some real specs)' do
      get online_exam_section_section_items_path(online_exam, section1)
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /diagnostic_test/:diagnostic_test_id/sections/:section_id/section_items' do
    it 'works! (now write some real specs)' do
      get diagnostic_test_section_section_items_path(diagnostic_test, section2)
      expect(response).to have_http_status(200)
    end
  end
end
