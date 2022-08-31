require 'rails_helper'

describe SectionItemPolicy do
  let(:student) { FactoryGirl.create :user }
  let(:other) { FactoryGirl.create :user, :superadmin }
  let(:online_exam) { FactoryGirl.create :online_exam }
  let(:section) { FactoryGirl.create :section, sectionable: online_exam }
  let(:section_item) { FactoryGirl.create :section_item, section: section }
  let(:published_online_exam) { FactoryGirl.create(:online_exam, :published_with_sections) }
  let(:published_section) { FactoryGirl.create :section, sectionable: published_online_exam }
  let(:published_section_item) { FactoryGirl.create :section_item, section: published_section }

  subject { described_class }
  context 'when superadmin, admin, manager, tutor' do
    permissions '.scope' do
      it 'can view all section items' do
        expect { SectionItemPolicy::Scope.new(other, SectionItem).resolve }.not_to raise_error
      end
    end

    permissions :show? do
      it 'can view secion item' do
        expect(subject).to permit(other, section_item)
      end

      it 'can view published section item' do
        expect(subject).to permit(other, published_section_item)
      end
    end

    permissions :create? do
      it 'can create a section item' do
        expect(subject).to permit(other, section_item)
      end
    end

    permissions :update? do
      it 'can update a section item' do
        expect(subject).to permit(other, section_item)
      end
    end

    permissions :destroy? do
      it 'can destory a section item' do
        expect(subject).to permit(other, section_item)
      end
    end
  end

  context 'when student' do
    permissions '.scope' do
      it 'can not view all sections' do
        expect { SectionItemPolicy::Scope.new(student, SectionItem).resolve }.to raise_error(
          Pundit::NotAuthorizedError)
      end
    end

    permissions :show? do
      it 'cannot view a section_item' do
        expect(subject).not_to permit(student, section_item)
        expect(subject).not_to permit(student, published_section_item)
      end
    end

    permissions :create? do
      it 'cannot create' do
        expect(subject).not_to permit(student, section_item)
      end

      it 'can not create if exam is alrady published' do
        expect(subject).not_to permit(student, published_section_item)
      end
    end

    permissions :update? do
      it 'cannot update' do
        expect(subject).not_to permit(student, section_item)
      end

      it 'can not update if exam is alrady published' do
        expect(subject).not_to permit(student, published_section_item)
      end
    end

    permissions :destroy? do
      it 'cannot destroy' do
        expect(subject).not_to permit(student, section_item)
      end

      it 'can not destroy if exam is alrady published' do
        expect(subject).not_to permit(student, published_section_item)
      end
    end
  end
end
