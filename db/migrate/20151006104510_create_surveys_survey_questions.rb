class CreateSurveysSurveyQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :survey_questions do |t|
      t.references :survey, index: true, foreign_key: true
      t.text :question

      t.timestamps null: false
    end
  end
end
