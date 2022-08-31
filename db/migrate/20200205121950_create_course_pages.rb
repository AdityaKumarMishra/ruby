class CreateCoursePages < ActiveRecord::Migration[6.1]
  def change
    create_table :course_pages do |t|

      t.timestamps null: false
      t.string :name
      t.boolean :active_page, default: false
    end
  end
end
