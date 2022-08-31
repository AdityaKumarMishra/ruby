require 'rails_helper'

RSpec.describe CommentPolicy do
  let(:student) { FactoryGirl.create :user }
  let(:student2) { FactoryGirl.create :user, :student }
  let(:tutor) { FactoryGirl.create :user, :tutor }
  let(:comment) { FactoryGirl.create :comment, user: student }
  let(:public_answer) { FactoryGirl.create :ticket_answer, public: true }
  let(:answer) { FactoryGirl.create :ticket_answer }
  let(:comment_with_public_answer) { FactoryGirl.create :comment, commentable: public_answer, user: student }
  let(:comment_with_answer) { FactoryGirl.create :comment, commentable: answer, user: student }
  let(:from_different_user) { FactoryGirl.create :comment, commentable: public_answer }
  subject { described_class }

  context 'when student' do
    permissions '.scope' do
      pending "add some examples to (or delete) #{__FILE__}"
    end

    permissions :show? do
      it 'can see comment if the answer is public' do
        expect(subject).to permit(student, comment_with_public_answer)
      end
    end

    permissions :create? do
      it 'can create if its own commentable' do
        expect(subject).to permit(student, comment_with_public_answer)
      end

      it 'can create if its own created' do
        expect(subject).to permit(student, comment_with_answer)
      end
      it 'cannot create if its others and not public' do
        expect(subject).not_to permit(student2, comment_with_answer)
      end
    end

    permissions :update? do
      it 'can update his/her own comment' do
        expect(subject).to permit(student, comment_with_public_answer)
        expect(subject).to permit(student, comment)
      end

      it 'can not delete others comment' do
        expect(subject).not_to permit(student, from_different_user)
        expect(subject).not_to permit(student, public_answer)
      end
    end

    permissions :destroy? do
      it 'can delete his/her own comment' do
        expect(subject).to permit(student, comment_with_public_answer)
      end

      it 'can not delete others comment' do
        expect(subject).not_to permit(student, from_different_user)
        expect(subject).not_to permit(student, public_answer)
      end
    end
  end
end
