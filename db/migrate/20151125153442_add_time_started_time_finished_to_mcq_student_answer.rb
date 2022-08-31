class AddTimeStartedTimeFinishedToMcqStudentAnswer < ActiveRecord::Migration[6.1]
  def change
    add_column :mcq_student_answers, :time_started, :datetime
    add_column :mcq_student_answers, :time_finished, :datetime
  end
end
