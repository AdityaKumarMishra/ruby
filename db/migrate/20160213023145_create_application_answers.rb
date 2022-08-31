class CreateApplicationAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :application_answers do |t|
      t.integer :job_application_id
      t.integer :application_question_id
      t.text :content

      t.timestamps null: false
    end
  end
end
