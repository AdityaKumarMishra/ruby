class CreateApplicationQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :application_questions do |t|
      t.integer :job_application_form_id
      t.text :content
      t.integer :answer_type

      t.timestamps null: false
    end
  end
end
