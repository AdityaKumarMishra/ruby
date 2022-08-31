class QuestionaresMcqs < ActiveRecord::Migration[6.1]
  def change
    create_join_table :questionaires,:mcqs
  end
end
