module IssueForumHelper

  def fetch_redirect_path(ticket)
    case ticket.given_type
    when 'Exercise'
      path = review_exercise_exercise_review_path(exercise_id: ticket.given_id, ticket_id: ticket.id)
    when 'SectionAttempt'
      section_attempt = SectionAttempt.find(ticket.given_id)
      if section_attempt.assessment_attempt.assessable_type == 'DiagnosticTest'
        path = review_diagnostic_test_attempt_section_attempt_section_item_attempts_path(section_attempt.assessment_attempt, section_attempt, ticket_id: ticket.id)
      else
        path = review_online_exam_attempt_section_attempt_section_item_attempts_path(section_attempt.assessment_attempt, section_attempt, ticket_id: ticket.id)
      end
    end
    path
  end
end
