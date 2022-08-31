# Preview all emails at http://localhost:3000/rails/mailers/ticket_mailer
class TicketMailerPreview < ActionMailer::Preview

	def new_question
		TicketMailer.new_question(FactoryGirl.create(:ticket))
	end

  def new_answer
    TicketMailer.new_answer(FactoryGirl.create(:ticket_answer))
  end

  def new_comment_tutor
    TicketMailer.new_comment_tutor(FactoryGirl.create(:comment))
  end

  def new_comment_student
    TicketMailer.new_comment_student(FactoryGirl.create(:comment))
  end

end
