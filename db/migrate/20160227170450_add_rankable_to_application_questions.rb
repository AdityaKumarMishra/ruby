class AddRankableToApplicationQuestions < ActiveRecord::Migration[6.1]
  def change
    add_column :application_questions, :rankable, :boolean
  end
end
