class CourseRecommenderUsagesController < ApplicationController
  protect_from_forgery except: :tracking
  layout 'layouts/dashboard'
  def index
    @skipped = CourseRecommenderUsage.find_by(course_name: "skip")
    @incompleted = CourseRecommenderUsage.find_by(course_name: "incomplete")
    @completed = CourseRecommenderUsage.sum(:complete)
    @skip_count = @skipped ? @skipped.skip : 0
    @incomplete_count = @incompleted ? @incompleted.incomplete : 0
    @usage_rate = @completed.to_f / (@completed + @skip_count + @incomplete_count).to_f
    @recommended = CourseRecommenderUsage.course_recommended
  end

  def tracking
    @course_recommended = CourseRecommenderUsage.find_by(course_name: params[:course_name])
    @product_line = params[:product_line]
    @subject = params[:subject]
    if @course_recommended
      @usage = @course_recommended
      @usage.update_attribute(:product_line, @product_line) if @course_recommended.product_line.nil?
    else
      @usage = CourseRecommenderUsage.new
      @usage.update(course_name: params[:course_name], product_line: @product_line, subject: @subject)
    end
    if params[:course_name] == "skip"
      @usage.update_attribute(:skip, @usage.skip + 1)
    elsif params[:course_name] == "incomplete"
      @usage.update_attribute(:incomplete, @usage.incomplete + 1)
    else
      @usage.update_attribute(:complete, @usage.complete + 1)
    end
    respond_to do |format|
      format.html { redirect_to root_path }
    end
  end
end
