require 'rails_helper'

describe AssessmentAttemptPolicy do
  let!(:student) { FactoryGirl.create :user, :student }
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
  subject { described_class }

  permissions :diagnostic_test_index? do
    xit 'student can view diagnostic test attempts whose courses are not expired' do
      student.update_attribute(:active_course_id, course.id)
      expect(subject).to permit(student)
    end
  end

  permissions :online_exams_index? do
    context 'when a student' do
      let!(:student1) { FactoryGirl.create :user, :student }
      let!(:productVer) { FactoryGirl.create(:product_version) }
      let!(:course) { FactoryGirl.create(:course, expiry_date: Date.today + 5.day, product_version_id: productVer.id) }
      let!(:enrolment) { FactoryGirl.create(:enrolment, course: course) }
      let!(:order1) { FactoryGirl.create(:order, status: :paid, user: student1) }
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
      let!(:paid_purchase_item) { FactoryGirl.create(:purchase_item, user: student1, order: order1, purchasable: enrolment) }
      it 'student can attempts online exam whose courses are not expired' do
        student1.update_attribute(:active_course_id, course.id)
        expect(subject).to permit(student1)
      end
    end
  end
end
