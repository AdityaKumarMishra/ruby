class CourseService
  def params(params)
    params[:course][:city] = params[:course][:city].to_i if params[:course][:city]
  end
  def initialize(course,params)
    @course= course
    @params= params
  end

  def duplicate
    c_name = @course.name + ' (copy)'

    duplicate_course = Course.new(name: c_name, class_size: @course.class_size,
                                  expiry_date: @course.expiry_date,
                                  enrolment_end_date: @course.enrolment_end_date,
                                  product_version_id: @course.product_version_id,
                                  essay_time: @course.essay_time,
                                  trial_period_days: @course.trial_period_days, city: @course.city,
                                  remain_visible: @course.remain_visible 
                                 )

    @course.lessons.each do |lesson|
      duplicate_course.lessons.new(date: lesson.date, location: lesson.location,
                                    start_time: lesson.start_time, end_time: lesson.end_time,
                                    item_covered: lesson.item_covered, lesson_type: lesson.lesson_type
                                   )
    end
    @course.course_staffs.each do |staff|
      duplicate_course.course_staffs.new(staff_profile_id: staff.staff_profile_id)
    end
    if duplicate_course.product_version.present? && duplicate_course.product_version.name == "GM 3.1 Free Trial"
      duplicate_course.customable = true
    end
    duplicate_course.save
    if duplicate_course.save(validate: false)
      msg = 'Course is duplicated successfully!'
    else
      msg = 'Error in duplicating course, please try again later!'
    end
    return msg, duplicate_course

  end


  
end

