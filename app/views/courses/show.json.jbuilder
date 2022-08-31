json.extract! @course, :id, :name, :class_size, :expiry_date, :enrolment_end_date, :product_version_id, :created_at, :updated_at, :city
json.name @course.product_version.name
json.price @course.product_version.price + @course.tax
json.type @course.product_version.type
