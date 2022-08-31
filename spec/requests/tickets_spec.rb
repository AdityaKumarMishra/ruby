require 'rails_helper'

RSpec.describe 'Tickets', type: :request do
  include RequestSpecHelper
  let(:student) { FactoryGirl.create :user }
  let!(:productVer) { FactoryGirl.create(:product_version) }
  let!(:course) { FactoryGirl.create(:course, product_version_id: productVer.id) }
  let!(:enrolment) { FactoryGirl.create(:enrolment, course_id: course.id) }
  let!(:order) { FactoryGirl.create(:order, status: :paid, user: student) }
  let!(:master_feature) { FactoryGirl.create(:master_feature, name: 'GamsatGetClarityFeature', title: 'Get Clarity') }
  let!(:pvfp) do
    FactoryGirl.create(:product_version_feature_price,
                       master_feature: master_feature,
                       product_version: productVer, is_default: true
                      )
  end
  let!(:feature_log) do
    FactoryGirl.create(:feature_log, product_version_feature_price: pvfp,
                                     acquired: Time.zone.now, enrolment: enrolment
                      )
  end
  let!(:paid_purchase_item) { FactoryGirl.create(:purchase_item, user: student, order: order, purchasable: enrolment) }

  before(:each) do
    login(student)
  end
  # describe 'GET /tickets' do
  #   it 'works! (now write some real specs)' do
  #     get tickets_path
  #     expect(response).to have_http_status(200)
  #   end
  # end

  describe 'GET /ticketing/forum' do
    subject do
      student.update_attribute(:active_course_id, course.id)
      get url_for(controller: 'issue_forum', action: 'list', content_id: content.id, content_type: content.class)
    end

    context 'for textbooks' do
      let(:content) { FactoryGirl.create :textbook }
      it { expect(response).to have_http_status(200) }
      it { is_expected.to render_template('issue_forum/ticket_list') }
      it { is_expected.to render_template('tickets/_form_inputs') }
    end
  end
end
