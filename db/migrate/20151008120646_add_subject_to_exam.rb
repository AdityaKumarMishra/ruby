class AddSubjectToExam < ActiveRecord::Migration[6.1]
  def change
    add_reference :exams, :subject, index: true, foreign_key: true
  end
end
