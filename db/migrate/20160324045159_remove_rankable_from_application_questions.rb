class RemoveRankableFromApplicationQuestions < ActiveRecord::Migration[6.1]
  def change
    remove_column :application_questions, :rankable, :boolean
  end
end
