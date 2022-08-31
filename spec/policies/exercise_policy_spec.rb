require 'rails_helper'

describe ExercisePolicy do
  let!(:student) { FactoryGirl.create(:user, :student) }
  let!(:productVer) { FactoryGirl.create(:product_version) }
  let!(:master_feature) { FactoryGirl.create(:master_feature, name: 'GamsatMcqFeature', title: 'MCQs') }
  let!(:order) { FactoryGirl.create(:order, status: :paid, user: student) }
  let!(:pvfp) do
    FactoryGirl.create(:product_version_feature_price,
                       master_feature: master_feature,
                       product_version: productVer, is_default: true
                      )
  end
  let!(:course) { FactoryGirl.create(:course, product_version: productVer) }
  let!(:enrolment) { FactoryGirl.create(:enrolment, course: course) }

  let!(:feature_log) do
    FactoryGirl.create(:feature_log, product_version_feature_price: pvfp,
                                     acquired: DateTime.now, enrolment: enrolment
                      )
  end
  let!(:paid_purchase_item) { FactoryGirl.create(:purchase_item, user: student, order: order, purchasable: enrolment) }

  subject { described_class }

  permissions :new? do
    it 'student can create new exercise whose courses are not expired' do
      student.update_attribute(:active_course_id, course.id)
      expect(subject).to permit(student)
    end
  end
end
