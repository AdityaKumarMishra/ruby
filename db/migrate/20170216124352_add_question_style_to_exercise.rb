class AddQuestionStyleToExercise < ActiveRecord::Migration[6.1]
  def change
    add_column :exercises, :question_style, :integer, default: 0
    add_column :assessment_attempts, :question_style, :integer, default: 0
  end
end
