class RaterMailer < ApplicationMailer
  def low_rating(rate)
    # @rate = rate
    # @current_user = rate.rater
    # @rating = rate.stars
    # @id = rate.rateable.id
    # if @rate.rateable_type == "Mcq"
    #   @question_name = ActionView::Base.full_sanitizer.sanitize( rate.rateable.question).strip
    #   @mcq_stem = rate.rateable.mcq_stem
    # end
    # mail(to: check_environment ? DEFAULT_TO : "course.coordinator@gradready.com.au", subject: "#{@question_name} has received a low rating." )
  end


  def rating_feedback(rate, course)
    @rate = rate
    @current_user = rate.rater
    @rating = rate.stars
    @course_enrolled=course
    @id = rate.rateable.id

    cached_average =  @rate.rateable.average
    @avg = cached_average ? cached_average.avg : 0

    if @rate.rateable_type == "Mcq"
      @question_name = ActionView::Base.full_sanitizer.sanitize(rate.rateable.question).strip
      @mcq_stem = rate.rateable.mcq_stem
    else
      @question_name = ActionView::Base.full_sanitizer.sanitize(rate.rateable.title).strip
    end
    mail(to: check_environment ? DEFAULT_TO : "quality.assurance@gradready.com.au", subject: "#{@question_name} has received a low rating." )
  end

end
