require 'rails_helper'

describe DocumentPolicy do
  let!(:super_admin) { FactoryGirl.create :user, :superadmin }
  let!(:manager) { FactoryGirl.create :user, :manager }
  let!(:admin) { FactoryGirl.create :user, :admin }
  let!(:tutor) { FactoryGirl.create :user, :tutor }
  let!(:student) { FactoryGirl.create :user, :student }
  let!(:productVer) { FactoryGirl.create(:product_version) }
  let!(:course) { FactoryGirl.create(:course, expiry_date: Date.today + 5.day, product_version_id: productVer.id) }
  let!(:enrolment) { FactoryGirl.create(:enrolment, course: course) }
  let!(:order) { FactoryGirl.create(:order, status: :paid, user: student) }
  let!(:master_feature) { FactoryGirl.create(:master_feature, name: 'GamsatDocumentsFeature', title: 'Documents') }
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

  permissions :index? do
    it 'student can view documents whose courses are not expired' do
      student.update_attribute(:active_course_id, course.id)
      super_admin.update_attribute(:active_course_id, course.id)
      admin.update_attribute(:active_course_id, course.id)
      manager.update_attribute(:active_course_id, course.id)
      tutor.update_attribute(:active_course_id, course.id)
      expect(subject).to permit(student, super_admin, admin, manager, tutor)
    end
  end
end
