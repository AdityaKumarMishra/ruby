require 'rails_helper'

describe McqPolicy do
  let(:admin) { FactoryGirl.create :user, :admin }
  let(:superadmin) { FactoryGirl.create :user, :superadmin }
  let(:manager) { FactoryGirl.create :user, :manager }
  let(:tutor) { FactoryGirl.create :user, :tutor }
  let(:student) { FactoryGirl.create :user, :student }
  let(:mcq) { FactoryGirl.create :mcq }

  subject { described_class }

  context 'when staff (superdamin, admin, manager, tutor)' do
    permissions '.scope' do
      it 'access all mcqs' do
        expect(McqPolicy::Scope.new(superadmin, Mcq).resolve).to eq [mcq]
        expect(McqPolicy::Scope.new(admin, Mcq).resolve).to eq [mcq]
        expect(McqPolicy::Scope.new(manager, Mcq).resolve).to eq [mcq]
        expect(McqPolicy::Scope.new(tutor, Mcq).resolve).to eq [mcq]
      end
    end
    permissions :create? do
      it 'can create' do
        expect(subject).to permit(superadmin, mcq)
        expect(subject).to permit(admin, mcq)
        expect(subject).to permit(manager, mcq)
        expect(subject).to permit(tutor, mcq)
      end
    end

    permissions :update? do
      it 'can update' do
        expect(subject).to permit(superadmin, mcq)
        expect(subject).to permit(admin, mcq)
        expect(subject).to permit(manager, mcq)
        expect(subject).to permit(tutor, mcq)
      end
    end

    permissions :show? do
      it 'can show' do
        expect(subject).to permit(superadmin, mcq)
        expect(subject).to permit(admin, mcq)
        expect(subject).to permit(manager, mcq)
        expect(subject).to permit(tutor, mcq)
      end
    end

    permissions :destroy? do
      it 'can destroy' do
        expect(subject).to permit(superadmin, mcq)
        expect(subject).to permit(admin, mcq)
        expect(subject).to permit(manager, mcq)
        expect(subject).to permit(tutor, mcq)
      end
    end

    permissions :new? do
      it 'can access new' do
        expect(subject).to permit(superadmin, mcq)
        expect(subject).to permit(admin, mcq)
        expect(subject).to permit(manager, mcq)
        expect(subject).to permit(tutor, mcq)
      end
    end

    permissions :edit? do
      it 'can access edit' do
        expect(subject).to permit(superadmin, mcq)
        expect(subject).to permit(admin, mcq)
        expect(subject).to permit(manager, mcq)
        expect(subject).to permit(tutor, mcq)
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
          expect(subject).not_to permit(student, mcq)
        end
      end

      permissions :create? do
        it 'cannot create' do
          expect(subject).not_to permit(student, mcq)
        end
      end

      permissions :update? do
        it 'cannot update' do
          expect(subject).not_to permit(student, mcq)
        end
      end

      permissions :destroy? do
        it 'cannot destroy' do
          expect(subject).not_to permit(student, mcq)
        end
      end

      permissions :new? do
        it 'cannot access view' do
          expect(subject).not_to permit(student, mcq)
        end
      end

      permissions :edit? do
        it 'cannot access edit' do
          expect(subject).not_to permit(student, mcq)
        end
      end
    end
  end
end
