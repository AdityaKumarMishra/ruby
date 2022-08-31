class CreateStudyBuddies < ActiveRecord::Migration[6.1]
  def change
    create_table :study_buddies do |t|

      t.string :name,null: false
      t.string :email,null: false, default: ""
      t.string :phone_number
      t.boolean :grad_student, null: false
      t.integer :exam_to_prepare, null: false
      t.integer  "university_id", null: false
      t.integer  "degree_id", null: false
      t.integer  "city", null: false
      t.integer  "city_area", null: false
      t.string   "suburb"
      t.integer  "focus_area", null: false
      t.string   "focus_study"
      t.integer  "buddy_type"
      t.string "other_info"

      t.timestamps null: false
    end
  end
end
