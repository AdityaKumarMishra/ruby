class CreateAttemptedMcqs < ActiveRecord::Migration[6.1]
  def change
    create_table :attempted_mcqs do |t|
    	t.belongs_to :mcq
    	t.belongs_to :attemptable
    	t.string :attemptable_type
      t.timestamps null: false
    end
  end
end
