class CreateSurveysSurveys < ActiveRecord::Migration[6.1]
  def change
    create_table :surveys do |t|
      t.references :user, index: true, foreign_key: true
      t.string :title
      t.datetime :date_published
      t.datetime :date_start
      t.boolean :published
      t.datetime :date_closed

      t.timestamps null: false
    end
  end
end
