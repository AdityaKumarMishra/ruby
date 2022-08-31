class AddColCourses < ActiveRecord::Migration[6.1]
  def change
  	add_column :courses, :paypal_only, :boolean, deafult: false
  end
end
