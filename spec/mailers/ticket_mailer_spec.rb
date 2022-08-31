require "rails_helper"

RSpec.describe TicketMailer, type: :model do
  let(:ticket) {
    FactoryGirl.create :ticket
  }
  let(:ticket_answer) {
    FactoryGirl.create :ticket_answer, ticket: FactoryGirl.create(:ticket)
  }
  let(:comment) {
    FactoryGirl.create :comment
  }
  let(:tutor) {
    FactoryGirl.create(:user, :tutor)
  }
  let(:user) {
    FactoryGirl.create(:user, :admin)
  }

  let(:staff) {
    FactoryGirl.create(:user, :tutor)
  }

  let(:student) {
    FactoryGirl.create(:user, :student)
  }


  let(:ticket1) {
    FactoryGirl.create(:ticket, answerer_id: tutor.id, resolver_id: user.id, title: "sdsad",
      question: "dsadsasdafsafsd")
  }

  let(:course) {FactoryGirl.create(:course)}
  let(:mcq_stem) { FactoryGirl.create(:mcq_stem) }
  let!(:mcq) { FactoryGirl.create(:mcq, mcq_stem: mcq_stem) }
  let(:feedback_ticket) {
    FactoryGirl.create(:ticket, answerer_id: tutor.id, resolver_id: user.id, title: "test feedback", feedback: "Yes", asker_id: student.id , questionable_id: mcq.id, questionable_type: "Mcq",
      question: "hows my feedback")
  }

  context "with a html content" do
    let(:html_content) {
      "test<br>test2<br/>test3<br /><script type='javascript'>alert(555);</script>"
    }
    let(:sanitized_html_content) {
      "test<br>test2<br>test3<br>alert(555);"
    }

    describe ".new_answer" do
      it "sanitizes the email content" do
        ticket_answer.content = html_content
        TicketMailer.new_answer(ticket_answer).deliver_later
        message_delivery = instance_double(ActionMailer::MessageDelivery)
        allow(message_delivery).to receive(:deliver_later)
      end
    end

    describe ".transfer_ticket" do
      it "sanitizes the transfer email content" do
        ticket1.comment = html_content
        TicketMailer.transfer_ticket(ticket1, staff, user).deliver_later
        message_delivery = instance_double(ActionMailer::MessageDelivery)
        allow(message_delivery).to receive(:deliver_later)
      end
    end


    describe ".new_comment_student" do
      it "sanitizes the email content" do
        comment.content = html_content
        TicketMailer.new_comment_student(comment).deliver_later
        message_delivery = instance_double(ActionMailer::MessageDelivery)
        allow(message_delivery).to receive(:deliver_later)
      end
    end

    describe ".new_comment_tutor" do
      it "sanitizes the email content" do
        comment.content = html_content
        TicketMailer.new_comment_tutor(comment).deliver_later
        message_delivery = instance_double(ActionMailer::MessageDelivery)
        allow(message_delivery).to receive(:deliver_later)
      end
    end

    describe "#new_comment_assignee" do
      it "email to assignee of ticket when new comment" do
        comment.content = html_content
        TicketMailer.new_comment_assignee(comment).deliver_later
        message_delivery = instance_double(ActionMailer::MessageDelivery)
        allow(message_delivery).to receive(:deliver_later)
      end
    end


    describe "#answer_to_assigned_ticket" do
      it "email to assignee of ticket when new answer" do
        ticket_answer.content = html_content
        TicketMailer.answer_to_assigned_ticket(ticket_answer).deliver_later
        message_delivery = instance_double(ActionMailer::MessageDelivery)
        allow(message_delivery).to receive(:deliver_later)
      end
    end

    describe "#new_question_reminder" do
      it "sanitizes the email content" do
        ticket.question = html_content
        TicketMailer.new_question_reminder(ticket).deliver_later
        message_delivery = instance_double(ActionMailer::MessageDelivery)
        allow(message_delivery).to receive(:deliver_later)
      end
    end

    describe ".answer_satisfaction" do
      it "checks email is delivered successfully" do
        ticket.question = html_content
        TicketMailer.answer_satisfaction(ticket).deliver_later
      end
    end

    describe "#ticket_resolved" do
      it "deliver email for resolved ticket" do
        ticket.question = html_content
        TicketMailer.ticket_resolved(ticket).deliver_later
      end
    end

    describe "#assigned_ticket_resolved" do
      it "deliver email for resolved ticket by other user" do
        ticket1.question = html_content
        TicketMailer.assigned_ticket_resolved(ticket1).deliver_later
      end
    end

    describe "#check_response_regarding_question" do
      it "deliver email to student" do
        ticket.question = html_content
        TicketMailer.check_response_regarding_question(ticket).deliver_later
      end
    end

    describe "#escalate_mail_to_student" do
      it "deliver email to student for escalation confirmation" do
        ticket.question = html_content
        TicketMailer.escalate_mail_to_student(ticket).deliver_later
      end
    end

    describe "#escalate_mail_to_staff" do
      it "deliver email to staff for escalation of ticket" do
        ticket.question = html_content
        TicketMailer.escalate_mail_to_staff(ticket).deliver_later
      end
    end
  end

  context "with overseeing staff" do
    let(:overseeing_users) {
      [FactoryGirl.create(:user, email: "xxx@555.com")]
    }

    describe ".new_question_reminder" do
      it "sends email to the overseeing staff" do
        TicketMailer.new_question_reminder(ticket).deliver_later
      end
    end
  end

  describe "#unresolved_reminder" do
    it "send email to active ticket answerers" do
      TicketMailer.unresolved_reminder(ticket).deliver_later
    end
  end

  describe ".ticket_feedback" do
    it "deliver email to quality assurance team for feedback ticket" do
      TicketMailer.ticket_feedback(feedback_ticket, course).deliver_later
    end
  end
end
