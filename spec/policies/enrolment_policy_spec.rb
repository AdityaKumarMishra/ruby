require 'rails_helper'

RSpec.describe EnrolmentPolicy do
  let!(:user) { User.new }
  let!(:admin) { FactoryGirl.create :user, :admin }
  let!(:student) { FactoryGirl.create :user, :student }
  let!(:order) { FactoryGirl.create(:order, status: :paid, user: student) }
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

  let!(:paid_purchase_item) { FactoryGirl.create(:purchase_item, user: student, order: order, purchasable: enrolment) }
  subject { described_class }

  permissions ".scope" do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :show? do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :create? do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :update? do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :destroy? do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :student_course_enrolment? do
    it 'staff can enrol student' do
      expect(subject).to permit(admin, enrolment)
      expect(subject).not_to permit(student, enrolment)
    end
  end
end
