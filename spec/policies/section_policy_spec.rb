require 'rails_helper'

describe SectionPolicy do
  let(:student) { FactoryGirl.create :user }
  let(:superadmin) { FactoryGirl.create :user, :superadmin }
  let(:online_exam) { FactoryGirl.create :online_exam }
  let(:published_online_exam) { FactoryGirl.create(:online_exam, :published_with_sections) }
  let(:section) { FactoryGirl.create :section, sectionable: online_exam }
  let(:published_section) { FactoryGirl.create :section, sectionable: published_online_exam }

  subject { described_class }

  context 'when superadmin, admin, manager, tutor' do
    permissions '.scope' do
      it 'can view all section' do
        expect { SectionPolicy::Scope.new(superadmin, Section).resolve }.not_to raise_error
      end
    end

    permissions :show? do
      it 'can view a section' do
        expect(subject).to permit(superadmin, section)
        expect(subject).to permit(superadmin, published_section)
      end
    end

    permissions :create? do
      it 'can create' do
        expect(subject).to permit(superadmin, section)
      end

      it 'can create if exam is alrady published' do
        expect(subject).to permit(superadmin, published_section)
      end
    end

    permissions :update? do
      it 'can update' do
        expect(subject).to permit(superadmin, section)
      end

      it 'can update if exam is alrady published' do
        expect(subject).to permit(superadmin, published_section)
      end
    end

    permissions :destroy? do
      it 'can destroy' do
        expect(subject).to permit(superadmin, section)
      end

      it 'can destroy if exam is alrady published' do
        expect(subject).to permit(superadmin, published_section)
      end
    end
  end

  context 'when student' do
    permissions '.scope' do
      it 'can not view all sections' do
        expect { SectionPolicy::Scope.new(student, Section).resolve }.to raise_error(
          Pundit::NotAuthorizedError)
      end
    end

    permissions :show? do
      it 'cannot view a section' do
        expect(subject).not_to permit(student, section)
        expect(subject).not_to permit(student, published_section)
      end
    end

    permissions :create? do
      it 'cannot create' do
        expect(subject).not_to permit(student, section)
      end

      it 'can not create if exam is alrady published' do
        expect(subject).not_to permit(student, published_section)
      end
    end

    permissions :update? do
      it 'cannot update' do
        expect(subject).not_to permit(student, section)
      end

      it 'can not update if exam is alrady published' do
        expect(subject).not_to permit(student, published_section)
      end
    end

    permissions :destroy? do
      it 'cannot destroy' do
        expect(subject).not_to permit(student, section)
      end

      it 'can not destroy if exam is alrady published' do
        expect(subject).not_to permit(student, published_section)
      end
    end
  end
end
