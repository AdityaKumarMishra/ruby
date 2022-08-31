class RemoveColsFromOnlineExams < ActiveRecord::Migration[6.1]
  def change
    remove_column :online_exams, :exam_type
    remove_column :online_exams, :online_exam_template_id
  end
end
