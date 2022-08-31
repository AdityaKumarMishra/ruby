class CreateMcqAttemptAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :mcq_attempt_answers do |t|
    	t.belongs_to :mcq_attempt
    	t.belongs_to :mcq_answer
    	t.boolean :value
      t.timestamps null: false
    end
  end
end
