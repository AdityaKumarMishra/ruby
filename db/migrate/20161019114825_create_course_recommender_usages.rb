class CreateCourseRecommenderUsages < ActiveRecord::Migration[6.1]
  def change
    create_table :course_recommender_usages do |t|

      t.integer :incomplete, default: 0
      t.integer :skip, default: 0
      t.integer :complete, default: 0
      t.string :course_name
      t.string :product_line
      t.string :subject

      t.timestamps null: false
    end
  end
end
