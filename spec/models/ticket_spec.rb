require 'rails_helper'

RSpec.describe Ticket, type: :model do
  let(:asker) { FactoryGirl.create :user, first_name: 'test_asker', last_name: "test_asker_last", email: 'test_asker@abc.com', phone_number: '2345982345' }
  let(:answerer) { FactoryGirl.create :user, first_name: 'test_answerer', last_name: "test_answerer_last", email: 'test_answerer@testing.com', phone_number: '9874563210' }
  let(:ticket) { FactoryGirl.create :ticket, asker: asker}
  let(:no_asker_ticket) {FactoryGirl.create(:ticket, asker: nil, first_name: 'test_ticket', last_name: "test_last", email: 'test@abc.com', phone_number: '9874563210')}

  it { expect(ticket).to belong_to :resolver }
  it { should define_enum_for(:status) }
  it { should have_many(:comments).dependent(:destroy)}

  it 'validates presence of question' do
    expect(subject).to validate_presence_of(:question)
  end
  # it 'validates presence of asker' do
  #   expect(subject).to validate_presence_of(:asker)
  # end
  describe '#asker_firstname' do
    it "is will return ticket's first name" do
      expect(ticket.asker_firstname).to eq "test_asker"
    end
    it "is will return ticket asker's first name" do
      expect(no_asker_ticket.asker_firstname).to eq "test_ticket"
    end
  end

  describe '#asker_lastname' do
    it "is will return ticket's last name" do
      expect(ticket.asker_lastname).to eq "test_asker_last"
    end
    it "is will return ticket asker's last name" do
      expect(no_asker_ticket.asker_lastname).to eq "test_last"
    end
  end

  describe '#asker_email' do
    it "is will return ticket's email" do
      expect(ticket.asker_email).to eq "test_asker@abc.com"
    end
    it "is will return ticket asker's email" do
      expect(no_asker_ticket.asker_email).to eq "test@abc.com"
    end
  end

  describe '#asker_phonenumber' do
    it "is will return ticket's phone number" do
      expect(ticket.asker_phonenumber).to eq "2345982345"
    end
    it "is will return ticket asker's phone number" do
      expect(no_asker_ticket.asker_phonenumber).to eq "9874563210"
    end
  end

  describe '#asker_full_name' do
    it "is will return ticket's and asker' full name" do
      expect(ticket.asker_full_name).to eq "#{ticket.asker_firstname} #{ticket.asker_lastname}"
    end
  end

  describe '.overdue' do
    let!(:not_overdue_ticket) {
      [
        FactoryGirl.create(:ticket, created_at: 1.days.ago)
      ]
    }

    let!(:overdue_tickets) {
      [
        FactoryGirl.create(:ticket, created_at: 2.months.ago),
        FactoryGirl.create(:ticket, created_at: 3.months.ago)
      ]
    }
    it 'returns unanswered overdue tickets' do
      expect(Ticket.overdue).to match_array(overdue_tickets)
    end
  end

  describe '.old_unanswered' do
    let!(:not_overdue_ticket) {
      [
        FactoryGirl.create(:ticket, created_at: 2.days.ago),
        FactoryGirl.create(:ticket, created_at: 6.days.ago),
      ]
    }

    let!(:overdue_tickets) {
      [
        FactoryGirl.create(:ticket, created_at: 15.days.ago),
        FactoryGirl.create(:ticket, created_at: 20.days.ago)
      ]
    }
    it 'returns old unanswered tickets' do
      expect(Ticket.old_unanswered).to match_array(overdue_tickets)
    end
  end

  describe '#unresolved_tickets' do
    let!(:unresolved_tickets) {
      [
        FactoryGirl.create(:ticket, title: 'ticket1', status: 1),
        FactoryGirl.create(:ticket, title: 'ticket2', status: 1)
      ]
    }
    let!(:resolved_tickets) {
      [
        FactoryGirl.create(:ticket, status: 2)
      ]
    }
    it 'returns unresolved tickets' do
      expect(Ticket.unresolved_tickets).to match_array(unresolved_tickets)
    end
  end

  describe '#two_day_old_tickets' do
    let!(:two_day_old_ticket) {
      [
        FactoryGirl.create(:ticket, title: 'ticket1', created_at: Time.zone.now - 2.day),
        FactoryGirl.create(:ticket, title: 'ticket2', created_at: Time.zone.now - 2.day)
      ]
    }
    let!(:three_day_old_ticket) {
      [
        FactoryGirl.create(:ticket, title: 'ticket2', created_at: Time.zone.now - 3.day)
      ]
    }
    it 'returns two days old tickets' do
      expect(Ticket.two_day_old_tickets).to match_array(two_day_old_ticket)
    end
  end

  describe '#send_enable_reminder' do
    let!(:unresolved_tickets) {
      FactoryGirl.create(:ticket, title: 'ticket1', status: 1, answerer_id: answerer.id)
    }
    xit 'send reminder mail to unresolved tickets' do
      expect(Ticket.send_enable_reminder).to eq([unresolved_tickets])
      expect(TicketMailer.unresolved_reminder(ticket).deliver_later)
    end
  end

  describe '#options_for_statuses' do
    it 'returns all statuses of ticket' do
      status = status
      allow(status).to receive(:ticket).and_return('resolved', 'unresolved', 'follow_up_required')
      expect(status.ticket).to eq('resolved')
      expect(status.ticket).to eq('unresolved')
      expect(status.ticket).to eq('follow_up_required')
    end
  end
end
