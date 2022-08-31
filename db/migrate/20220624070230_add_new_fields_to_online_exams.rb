class AddNewFieldsToOnlineExams < ActiveRecord::Migration[6.1]
  def change
    add_column :online_exams, :exam_type, :integer
    add_column :online_exams, :online_exam_template_id, :integer, index: true
  end
end
