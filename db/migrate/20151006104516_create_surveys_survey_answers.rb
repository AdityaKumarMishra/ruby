class CreateSurveysSurveyAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :survey_answers do |t|
      t.references :user, index: true, foreign_key: true
      t.references :survey_question, index: true, foreign_key: true
      t.text :answer
      t.integer :rating

      t.timestamps null: false
    end
  end
end
