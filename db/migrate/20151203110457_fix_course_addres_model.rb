class FixCourseAddresModel < ActiveRecord::Migration[6.1]
  def up
    add_column :course_addresses, :city, :string
    add_column :course_addresses, :institution_name, :string
    add_reference :course_versions, :course_address, index: true, foreign_key: true
    remove_column :course_addresses, :addresable_id
    remove_column :course_addresses, :addresable_type, :string
    remove_reference :course_addresses, :area
  end

  def down
    remove_column :course_addresses, :city, :string
    remove_column :course_addresses, :institution_name, :string
    remove_reference :course_versions, :course_address, index: true, foreign_key: true
    add_column :course_addresses, :addresable_id, :integer
    add_column :course_addresses, :addresable_type, :string
    add_reference :course_addresses, :area, index: true, foreign_key: true
  end
end
