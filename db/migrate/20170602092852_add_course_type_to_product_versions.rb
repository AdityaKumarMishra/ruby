class AddCourseTypeToProductVersions < ActiveRecord::Migration[6.1]
  def change
    add_column :product_versions, :course_type, :integer
  end
end
