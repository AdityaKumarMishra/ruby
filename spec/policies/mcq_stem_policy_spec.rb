require 'rails_helper'

describe McqStemPolicy do
  let(:admin) { FactoryGirl.create :user, :admin }
  let(:superadmin) { FactoryGirl.create :user, :superadmin }
  let(:manager) { FactoryGirl.create :user, :manager }
  let(:tutor) { FactoryGirl.create :user, :tutor }
  let(:student) { FactoryGirl.create :user, :student }
  let(:mcq_stem) { FactoryGirl.create :mcq_stem, title: "test_mcq_stem" }

  subject { described_class }

  context 'when staff (superadmin, admin, manager, tutor)' do
    permissions '.scope' do
      it 'access all mcqstems' do
        expect(McqStemPolicy::Scope.new(superadmin, McqStem).resolve).to eq [mcq_stem]
        expect(McqStemPolicy::Scope.new(admin, McqStem).resolve).to eq [mcq_stem]
        expect(McqStemPolicy::Scope.new(manager, McqStem).resolve).to eq [mcq_stem]
        expect(McqStemPolicy::Scope.new(tutor, McqStem).resolve).to eq [mcq_stem]
      end
    end

    permissions :create? do
      it 'can create mcqstem' do
        expect(subject).to permit(superadmin, mcq_stem)
        expect(subject).to permit(admin, mcq_stem)
        expect(subject).to permit(manager, mcq_stem)
        expect(subject).to permit(tutor, mcq_stem)
      end
    end

    permissions :update? do
      it 'can update' do
        expect(subject).to permit(superadmin, mcq_stem)
        expect(subject).to permit(admin, mcq_stem)
        expect(subject).to permit(manager, mcq_stem)
        expect(subject).to permit(tutor, mcq_stem)
      end
    end

    permissions :show? do
      it 'can show' do
        expect(subject).to permit(superadmin, mcq_stem)
        expect(subject).to permit(admin, mcq_stem)
        expect(subject).to permit(manager, mcq_stem)
        expect(subject).to permit(tutor, mcq_stem)
      end
    end

    permissions :destroy? do
      it 'can destroy' do
        expect(subject).to permit(superadmin, mcq_stem)
        expect(subject).to permit(admin, mcq_stem)
        expect(subject).to permit(manager, mcq_stem)
        expect(subject).to permit(tutor, mcq_stem)
      end
    end

    permissions :new? do
      it 'can access new' do
        expect(subject).to permit(superadmin, mcq_stem)
        expect(subject).to permit(admin, mcq_stem)
        expect(subject).to permit(manager, mcq_stem)
        expect(subject).to permit(tutor, mcq_stem)
      end
    end

    permissions :edit? do
      it 'can access edit' do
        expect(subject).to permit(superadmin, mcq_stem)
        expect(subject).to permit(admin, mcq_stem)
        expect(subject).to permit(manager, mcq_stem)
        expect(subject).to permit(tutor, mcq_stem)
      end
    end
  end
  context 'when student' do
    # This test is no longer needed - students do have an MCQ Stem scope now
    # permissions '.scope' do
    #   it 'cannot access' do
    #     expect { McqStemPolicy::Scope.new(student, McqStem).resolve }.to raise_error Pundit::NotAuthorizedError
    #   end
    # end

    permissions :show? do
      it 'cannot view' do
        expect(subject).not_to permit(student, mcq_stem)
      end
    end

    permissions :create? do
      it 'cannot create' do
        expect(subject).not_to permit(student, mcq_stem)
      end
    end

    permissions :update? do
      it 'cannot update' do
        expect(subject).not_to permit(student, mcq_stem)
      end
    end

    permissions :destroy? do
      it 'cannot destroy' do
        expect(subject).not_to permit(student, mcq_stem)
      end
    end

    permissions :new? do
      it 'cannot access view' do
        expect(subject).not_to permit(student, mcq_stem)
      end
    end

    permissions :edit? do
      it 'cannot access edit' do
        expect(subject).not_to permit(student, mcq_stem)
      end
    end
  end
end
