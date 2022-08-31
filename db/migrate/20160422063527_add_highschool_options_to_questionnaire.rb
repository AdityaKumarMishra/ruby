class AddHighschoolOptionsToQuestionnaire < ActiveRecord::Migration[6.1]
  def change
    add_column :questionnaires, :student_level, :integer, default: 0
    add_column :questionnaires, :highschool_year_level, :integer

    add_column :questionnaires, :current_highschool, :string
    add_column :questionnaires, :target_uni_course, :string
  end
end
