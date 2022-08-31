class CreateAnswerOptions < ActiveRecord::Migration[6.1]
  def change
    create_table :answer_options do |t|
      t.integer :application_question_id
      t.string :content

      t.timestamps null: false
    end
  end
end
