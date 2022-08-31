class AddColumnStudentRegionToQuestionnaires < ActiveRecord::Migration[6.1]
  def change
    add_column :questionnaires, :student_region, :integer
  end
end
