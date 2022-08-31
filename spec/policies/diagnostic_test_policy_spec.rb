require 'rails_helper'

describe OnlineExamPolicy do
  let(:tag1) { FactoryGirl.create :tag, name: 'Gamsat' }
  let(:tag2) { FactoryGirl.create :tag, name: 'Umat' }

  let(:diagnostic_test) { FactoryGirl.create :diagnostic_test, tags: [tag1] }
  let(:published_diagnostic_test) do
    FactoryGirl.create :diagnostic_test,
                       published: true, tags: [tag2]
  end
  let(:published_tagged_diagnostic_test) do
    FactoryGirl.create :diagnostic_test,
                       published: true, tags: [tag1]
  end

  let(:student) { FactoryGirl.create :user }
  let(:other) { FactoryGirl.create :user, :superadmin }

  let!(:productVer) { FactoryGirl.create(:product_version) }
  let!(:master_feature) { FactoryGirl.create(:master_feature, name: 'Diagnostics Feature') }

  let!(:pvfp) do
    FactoryGirl.create(:product_version_feature_price,
                       master_feature: master_feature, product_version: productVer)
  end

  let!(:tagging) { FactoryGirl.create(:tagging, tag: tag1, taggable: pvfp) }
  let!(:course) { FactoryGirl.create(:course, product_version: productVer) }

  let!(:order) { FactoryGirl.create(:order, status: :paid, user: student) }
  let!(:enrol) { FactoryGirl.create(:enrolment, course: course) }
  let!(:feature_log) do
    FactoryGirl.create(:feature_log, product_version_feature_price: pvfp,
                                     acquired: DateTime.now, enrolment: enrol
                      )
  end
  let!(:paid_purchase_item) { FactoryGirl.create(:purchase_item, user: student, order: order, purchasable: enrol) }

  subject { described_class }

  context 'when a student' do
    permissions '.scope' do
      it 'can see all published exams' do
        student.update_attribute(:active_course_id, course.id)
        FactoryGirl.create :diagnostic_test, tags: [tag2]
        d2 = FactoryGirl.create :diagnostic_test, published: true, tags: [tag1]
        expect(DiagnosticTestPolicy::Scope.new(student, DiagnosticTest).resolve).to eq [d2]
      end
    end

    permissions :show? do
      it 'cannot view exam not published' do
        expect(subject).not_to permit(student, diagnostic_test)
      end

      it 'cannot view exams with wrong tags' do
        expect(subject).not_to permit(student, published_diagnostic_test)
      end

      it 'cannot view published exam with right tags' do
        expect(subject).not_to permit(student, published_tagged_diagnostic_test)
      end
    end

    permissions :create? do
      it 'cannot create an exam' do
        expect(subject).not_to permit(student, diagnostic_test)
      end
    end

    permissions :update? do
      it 'cannot update an exam' do
        expect(subject).not_to permit(student, diagnostic_test)
      end
    end

    permissions :destroy? do
      it 'cannot destroy an exam' do
        expect(subject).not_to permit(student, diagnostic_test)
      end
    end
  end

  context 'when other user group' do
    permissions '.scope' do
      xit 'can see all exams' do
        d1 = FactoryGirl.create :diagnostic_test
        d2 = FactoryGirl.create :diagnostic_test, published: true
        expect(DiagnosticTestPolicy::Scope.new(other, DiagnosticTest).resolve).to eq [d1, d2]
      end
    end

    permissions :show? do
      it 'can view exam' do
        expect(subject).to permit(other, diagnostic_test)
      end
    end

    permissions :create? do
      it 'can create an exam' do
        expect(subject).to permit(other, diagnostic_test)
      end
    end

    permissions :update? do
      it 'can update an exam' do
        expect(subject).to permit(other, diagnostic_test)
      end

      it 'can update published exam' do
        expect(subject).to permit(other, published_diagnostic_test)
      end
    end

    permissions :destroy? do
      context 'when unpublished' do
        it 'can destroy an exam' do
          expect(subject).to permit(other, diagnostic_test)
        end
      end
    end
  end
end
