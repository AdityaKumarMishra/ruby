class EssayTutorMailer < ApplicationMailer
  def low_tutor_mark(essay_response, tutor)
    # @essay_response = essay_response
    # @tutor = tutor
    # @user = @essay_response.user
    # mail(
    #   to: check_environment ? DEFAULT_TO : essay_management,
    #   subject: "Low Tutor feedback - #{@tutor.staff.full_name}"
    # )
  end

  def inform_tutor(essay_response, tutor)
    @essay_response = essay_response
    @tutor = tutor
    @user = @essay_response.user
    mail(
      to: check_environment ? DEFAULT_TO : @tutor.staff.email,
      subject: "Feedback from - #{@user.full_name}"
    )
  end

  def feedback_comment_by_tutor(comment)
    @comment = comment
    mail(to: check_environment ? DEFAULT_TO : @comment.commentable.user.email, subject: "Tutor has replied to your feedback")
  end

  def feedback_comment_by_student(comment)
    @comment = comment
    mail(to: check_environment ? DEFAULT_TO : @comment.commentable.essay_response.essay_tutor_response.staff_profile.staff.email, subject: "Student has replied to your feedback.")
  end
end
