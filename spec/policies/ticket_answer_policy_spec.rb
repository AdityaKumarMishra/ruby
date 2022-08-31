require 'rails_helper'

RSpec.describe TicketAnswerPolicy do
  let(:student) { FactoryGirl.create :user }
  let(:other) { FactoryGirl.create :user, :tutor }
  let(:ticket) { FactoryGirl.create :ticket }
  let(:ticket_answer) { FactoryGirl.create :ticket_answer, ticket_id: ticket.id }
  let(:public_answer) { FactoryGirl.create :ticket_answer, public: true, ticket_id: ticket.id }

  subject { described_class }

  context 'student' do
    permissions '.scope' do
      it 'can see public answers' do
        expect(TicketAnswerPolicy::Scope.new(student, TicketAnswer).resolve).to eq [public_answer]
      end
    end

    permissions :show? do
      it 'can see a public answer' do
        expect(subject).to permit(student, public_answer)
      end

      it 'can not see a normal answer' do
        expect(subject).not_to permit(student, ticket_answer)
      end
    end

    permissions :create? do
      it 'can not create an answer' do
        expect(subject).not_to permit(student, ticket_answer)
      end
    end

    permissions :update? do
      it 'can not update an answer' do
        expect(subject).not_to permit(student, ticket_answer)
      end
    end

    permissions :destroy? do
      it 'can not destroy an answer' do
        expect(subject).not_to permit(student, ticket_answer)
      end
    end
  end

  context 'when other user group' do
    permissions '.scope' do
      it 'can see all answers' do
        expect(TicketAnswerPolicy::Scope.new(other, TicketAnswer).resolve).to eq [ticket_answer, public_answer]
      end
    end

    permissions :show? do
      it 'can see a public answer' do
        expect(subject).to permit(other, public_answer)
      end

      it 'can see a normal answer' do
        expect(subject).to permit(other, ticket_answer)
      end
    end

    permissions :create? do
      it 'can create an answer' do
        expect(subject).to permit(other, ticket_answer)
      end
    end

    permissions :update? do
      it 'can update an answer' do
        expect(subject).to permit(other, ticket_answer)
      end

      it 'can update a public answer' do
        expect(subject).to permit(other, public_answer)
      end
    end

    permissions :destroy? do
      it 'can destroy an answer' do
        expect(subject).to permit(other, ticket_answer)
      end
    end
  end
end
