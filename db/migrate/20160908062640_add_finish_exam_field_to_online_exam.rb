class AddFinishExamFieldToOnlineExam < ActiveRecord::Migration[6.1]
  def change
    add_column :online_exams, :is_finish, :boolean, default: false
  end
end
