module CoursesHelper
  def available_cities
    Course.cities.map {|k, v| [k, v]}
  end

  def available_product_versions
    ProductVersion.order(:name).map { |product_version| ["#{product_version.name} #{product_version.course_type.present? ? "(#{product_version.course_type.titleize})" : ''} (#{product_version.type})", product_version.id] }
  end


  def line_product_versions(type)
    ProductVersion.by_product_line(type).order(:name).map { |product_version| ["#{product_version.name} #{product_version.course_type.present? ? "(#{product_version.course_type.titleize})" : ''} (#{product_version.type})", product_version.id] }
  end

  def available_product_line
    ProductLine.order(:name).map { |product_line| [product_line.name.capitalize,product_line.name.capitalize]}
  end

  def user_essay_resp_tutor(user, course_id)
    essay_responses = EssayResponse.includes(:tutor).where(user_id: user.id, course_id: course_id, status: 0)
    tutors = essay_responses.map{|er| er.tutor}.uniq
    tutors.map{|tutor| ["#{tutor.full_name}", tutor.id ] }
  end
end
