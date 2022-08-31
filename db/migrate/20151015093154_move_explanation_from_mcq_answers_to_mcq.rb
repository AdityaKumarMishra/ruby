class MoveExplanationFromMcqAnswersToMcq < ActiveRecord::Migration[6.1]
  def change
    remove_column :mcq_answers, :explanation
    add_column :mcqs, :explanation, :text
  end
end
