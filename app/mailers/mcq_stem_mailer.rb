class McqStemMailer < ApplicationMailer
  def to_review(user, mcq_stem)
    @user = user
    @mcq_stem = mcq_stem
    if @user.present?
	    mail(
	        to: check_environment ? DEFAULT_TO : @user.email,
	        subject: "You have a new MCQ to review",
	    )
	  # else
	  #   mail(
	  #   	to: check_environment ? DEFAULT_TO : "course.coordinator@gradready.com.au",
	  #   	subject: "MCQ_STEM NO REVIEWER"
	  #   )
	end
  end

end
