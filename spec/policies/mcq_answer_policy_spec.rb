require 'rails_helper'

describe McqAnswerPolicy do
  let(:admin) { FactoryGirl.create :user, :admin }
  let(:superadmin) { FactoryGirl.create :user, :superadmin }
  let(:manager) { FactoryGirl.create :user, :manager }
  let(:tutor) { FactoryGirl.create :user, :tutor }
  let(:student) { FactoryGirl.create :user, :student }
  let(:mcq_answer) { FactoryGirl.create :mcq_answer }

  subject { described_class }

  context 'when staff (superdamin, admin, manager, tutor)' do
    permissions '.scope' do
      it 'access all' do
        expect(McqAnswerPolicy::Scope.new(superadmin, McqAnswer).resolve).to eq [mcq_answer]
        expect(McqAnswerPolicy::Scope.new(admin, McqAnswer).resolve).to eq [mcq_answer]
        expect(McqAnswerPolicy::Scope.new(manager, McqAnswer).resolve).to eq [mcq_answer]
        expect(McqAnswerPolicy::Scope.new(tutor, McqAnswer).resolve).to eq [mcq_answer]
      end
    end
    permissions :create? do
      it 'can create' do
        expect(subject).to permit(superadmin, mcq_answer)
        expect(subject).to permit(admin, mcq_answer)
        expect(subject).to permit(manager, mcq_answer)
        expect(subject).to permit(tutor, mcq_answer)
      end
    end

    permissions :update? do
      it 'can update' do
        expect(subject).to permit(superadmin, mcq_answer)
        expect(subject).to permit(admin, mcq_answer)
        expect(subject).to permit(manager, mcq_answer)
        expect(subject).to permit(tutor, mcq_answer)
      end
    end

    permissions :show? do
      it 'can show' do
        expect(subject).to permit(superadmin, mcq_answer)
        expect(subject).to permit(admin, mcq_answer)
        expect(subject).to permit(manager, mcq_answer)
        expect(subject).to permit(tutor, mcq_answer)
      end
    end

    permissions :destroy? do
      it 'can destroy' do
        expect(subject).to permit(superadmin, mcq_answer)
        expect(subject).to permit(admin, mcq_answer)
        expect(subject).to permit(manager, mcq_answer)
        expect(subject).to permit(tutor, mcq_answer)
      end
    end

    permissions :new? do
      it 'can access new' do
        expect(subject).to permit(superadmin, mcq_answer)
        expect(subject).to permit(admin, mcq_answer)
        expect(subject).to permit(manager, mcq_answer)
        expect(subject).to permit(tutor, mcq_answer)
      end
    end

    permissions :edit? do
      it 'can access edit' do
        expect(subject).to permit(superadmin, mcq_answer)
        expect(subject).to permit(admin, mcq_answer)
        expect(subject).to permit(manager, mcq_answer)
        expect(subject).to permit(tutor, mcq_answer)
      end
    end
    context 'when student' do
      permissions '.scope' do
        it 'cannot access' do
          expect(McqPolicy::Scope.new(student, Mcq).resolve).to eq []
        end
      end

      permissions :show? do
        it 'cannot view' do
          expect(subject).not_to permit(student, mcq_answer)
        end
      end

      permissions :create? do
        it 'cannot create' do
          expect(subject).not_to permit(student, mcq_answer)
        end
      end

      permissions :update? do
        it 'cannot update' do
          expect(subject).not_to permit(student, mcq_answer)
        end
      end

      permissions :destroy? do
        it 'cannot destroy' do
          expect(subject).not_to permit(student, mcq_answer)
        end
      end

      permissions :new? do
        it 'cannot access view' do
          expect(subject).not_to permit(student, mcq_answer)
        end
      end

      permissions :edit? do
        it 'cannot access edit' do
          expect(subject).not_to permit(student, mcq_answer)
        end
      end
    end
  end
end
