require 'rails_helper'

describe OnlineExamPolicy do
  let(:student) { FactoryGirl.create :user }
  let(:other) { FactoryGirl.create :user, :superadmin }
  let(:tag1) { FactoryGirl.create :tag, name: "Gamsat" }
  let(:tag2) { FactoryGirl.create :tag, name: "Umat" }

  let(:online_exam) { FactoryGirl.create :online_exam, tags: [tag1] }
  let(:published_online_exam) { FactoryGirl.create(:online_exam, :published_with_sections, tags: [tag2]) }
  let(:published_tagged_online_exam) { FactoryGirl.create(:online_exam, :published_with_sections, tags: [tag1]) }

  let!(:productVer) { FactoryGirl.create(:product_version) }
  let!(:master_feature) { FactoryGirl.create(:master_feature, name: 'ExamFeature') }
  # let!(:feat) { FactoryGirl.create(:feature, product_version: productVer, tags: [tag1]) }
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
      it 'can see published exams with right tags' do
        student.update_attribute(:active_course_id, course.id)
        FactoryGirl.create :online_exam, tags: [tag1]
        FactoryGirl.create(:online_exam, :published_with_sections, tags: [tag2])
        e3 = FactoryGirl.create(:online_exam, :published_with_sections, tags: [tag1])
        expect(OnlineExamPolicy::Scope.new(student, OnlineExam).resolve).to eq [e3]
      end
    end

    permissions :show? do
      it 'cannot view exam' do
        expect(subject).not_to permit(student, online_exam)
      end

      it 'cannot view published exam' do
        expect(subject).not_to permit(student, published_online_exam)
      end

      it 'cannot view published tagged exam' do
        expect(subject).not_to permit(student, published_tagged_online_exam)
      end
    end

    permissions :create? do
      it 'cannot create an exam' do
        expect(subject).not_to permit(student, online_exam)
      end
    end

    permissions :update? do
      it 'cannot update an exam' do
        expect(subject).not_to permit(student, online_exam)
      end
    end

    permissions :destroy? do
      it 'cannot destroy an exam' do
        expect(subject).not_to permit(student, online_exam)
      end
    end
  end

  context 'when other user group' do
    let(:e1) { FactoryGirl.create(:online_exam, tags: [tag2]) }
    let(:e2) { FactoryGirl.create(:online_exam, :published_with_sections, tags: [tag1]) }
    permissions '.scope' do
      it 'can see all exams' do
        expect(OnlineExamPolicy::Scope.new(other, OnlineExam).resolve).to match_array(OnlineExam.all)
      end
    end

    permissions :show? do
      it 'can view exam' do
        expect(subject).to permit(other, online_exam)
      end
    end

    permissions :create? do
      it 'can create an exam' do
        expect(subject).to permit(other, online_exam)
      end
    end

    permissions :update? do
      it 'can update an exam' do
        expect(subject).to permit(other, online_exam)
      end

      it 'can update published exam' do
        expect(subject).to permit(other, published_online_exam)
      end
    end

    permissions :destroy? do
      context 'when unpublished' do
        it 'can destroy an exam' do
          expect(subject).to permit(other, online_exam)
        end
      end
    end
  end
end
