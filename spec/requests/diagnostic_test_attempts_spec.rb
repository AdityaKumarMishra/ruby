require 'rails_helper'

RSpec.describe 'DiagnosticTestAttempts', type: :request do
  include RequestSpecHelper

  let(:student) { FactoryGirl.create :user, :student }
  # before(:each) do
  #   login(student)
  # end
  describe 'GET /diagnostic_test_attempts' do
    context 'GET /diagnostic_test_attempts' do
      let!(:productVer) { FactoryGirl.create(:product_version) }
      let!(:course) { FactoryGirl.create(:course, expiry_date: Date.today + 5.day, product_version_id: productVer.id) }
      let!(:enrolment) { FactoryGirl.create(:enrolment, course: course) }
      let!(:order) { FactoryGirl.create(:order, status: :paid, user: student) }
      let!(:master_feature) { FactoryGirl.create(:master_feature, name: 'Diagnostics Assessment', title: 'Diagnostics Assessment') }

      let!(:pvfp) do
        FactoryGirl.create(:product_version_feature_price,
                           master_feature: master_feature,
                           product_version: productVer, is_default: true
                          )
      end

      let!(:feature_log) do
        FactoryGirl.create(:feature_log, product_version_feature_price: pvfp,
                                         acquired: DateTime.now, enrolment: enrolment
                          )
      end
      let!(:paid_purchase_item) { FactoryGirl.create(:purchase_item, user: student, order: order, purchasable: enrolment) }
      it 'works! (now write some real specs)' do
        get diagnostic_test_attempts_path
        expect(response).to have_http_status(302)
      end
    end
  end
end
