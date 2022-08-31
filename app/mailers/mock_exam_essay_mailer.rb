class MockExamEssayMailer < ApplicationMailer
  def new_mock_essays(mock_exam_essay)
    @mock_exam_essay = mock_exam_essay
    @tutor_emails = User.where(id: @mock_exam_essay.assigned_tutors).pluck(:email)
    @tutor_emails = (@tutor_emails << 'tt@gradready.com.au').uniq
    @student = @mock_exam_essay.user
    @date = @mock_exam_essay.created_at
    mail(
      to: check_environment ? DEFAULT_TO : check_environment ? DEFAULT_TO : @tutor_emails,
      subject: "Mock Exam essays are available to answer"
    )
  end

  def tutor_feedback(feedback)
    @mock_exam_essay = feedback.mock_essay.mock_exam_essay
    @tutor = feedback.user
    @student = @mock_exam_essay.user
    mail(
      to: check_environment ? DEFAULT_TO : check_environment ? DEFAULT_TO : @student.email,
      subject: "A tutor responded to your mock exam essays"
    )
  end

  def partial_feeback_mail(mock_exam_essay)
    @mock_exam_essay = mock_exam_essay
    @student = @mock_exam_essay.user
    @tutor = User.where(id: @mock_exam_essay.assigned_tutors).first
    @date = @mock_exam_essay.created_at
    mail(
      to: check_environment ? DEFAULT_TO : check_environment ? DEFAULT_TO : [@tutor.email,"essay.coordinator@gradready.com.au"],
      subject: "[Reminder] - A student's 2nd essay has not yet been marked"
    )
  end

  def send_overdue_reminder(mock_exam_essay)
    @mock_exam_essay = mock_exam_essay
    @student = @mock_exam_essay.user
    @tutor = User.where(id: @mock_exam_essay.assigned_tutors).first
    @date = @mock_exam_essay.created_at
    mail(
      to: check_environment ? DEFAULT_TO : [@tutor.email, quality_assurance_email,"essay.coordinator@gradready.com.au"],
      subject: "[Overdue Reminder] - This mock exam essay is now overdue!"
    )
  end

  def new_tutor_assigned(mock_exam_essay)
    @mock_exam_essay = mock_exam_essay
    @student = @mock_exam_essay.user
    @tutor = User.where(id: @mock_exam_essay.assigned_tutors).first
    mail(
      to: check_environment ? DEFAULT_TO : @tutor.email,
      subject: "Re-assigned Mock Exam Essay - New Essay for Marking"
    )
  end

  def inform_old_tutor(mock_exam_essay, tutor)
    @mock_exam_essay = mock_exam_essay
    @student = @mock_exam_essay.user
    @new_tutor = User.where(id: @mock_exam_essay.assigned_tutors).first
    @tutor = tutor
    mail(
      to: check_environment ? DEFAULT_TO : tutor.email,
      subject: "Re-assigned Mock Exam Essay - Do Not Mark"
    )
  end
end
