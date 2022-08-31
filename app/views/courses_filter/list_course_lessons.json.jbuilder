json.extract! @course, :id, :name, :class_size, :expiry_date, :product_version_id
json.enrolment_end_date @course.enrolment_end_date.strftime('%d %b %Y')
json.expiry_date @course.expiry_date.strftime('%d %b %Y')
json.course_type @course.product_version.try(:course_type)
json.image_up @course.image_up
json.image_down @course.image_down
json.lessons do
  json.array! @course.lessons.try(:order, :date) do |lesson|
    json.date lesson.date.present? ? lesson.date.strftime('%d %b %Y') : ''
    json.location lesson.location
    json.start_time lesson.start_time.strftime('%I:%M %p')
    json.end_time lesson.end_time.strftime('%I:%M %p')
    json.item_covered lesson.item_covered
  end
end
