namespace :add_given_type_to_ticket do
  task add_asked_for: :environment do
    Ticket.where(questionable_type: 'Mcq').each do|ticket|
      asker = ticket.asker
      next if asker.nil?
      attempt = asker.mcq_attempts.where(id: ticket.questionable_id).first
      attempt1 = asker.section_item_attempts.includes(:mcq).where(mcqs: {id: ticket.questionable_id}).first
      if attempt.present?
        id = attempt.exercise_id
        type = 'Exercise'
        ticket.update(given_type: type, given_id: id)
        puts "exercise"
      elsif attempt1.present?
        id = attempt1.section_attempt_id
        type = 'SectionAttempt'
        ticket.update(given_type: type, given_id: id)
        puts "exam"
      end
    end
  end
end
