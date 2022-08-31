require "rails_helper"

RSpec.describe EnrolmentsMailer, type: :mailer do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:order) { FactoryGirl.create(:order, status: :paid, user: user) }
  let!(:enrolment) { FactoryGirl.create(:enrolment) }

  let!(:productVer) { FactoryGirl.create(:product_version) }
  let!(:master_feature) { FactoryGirl.create(:master_feature, name: 'GamsatExamFeature', title: 'Exams') }
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
  let!(:paid_purchase_item) { FactoryGirl.create(:purchase_item, user: user, order: order, purchasable: enrolment) }

  let!(:promo) { FactoryGirl.create(:promo, :tokened, generated_from_id: order.id) }

  describe "#discount_link_auto_email" do
    it 'sends student discount link email after course purchase' do
      enrolment.reload
      EnrolmentsMailer.discount_link_auto_email(enrolment).deliver_later
    end
  end
end
