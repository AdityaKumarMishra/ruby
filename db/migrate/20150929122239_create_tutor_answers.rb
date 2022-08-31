class CreateTutorAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :tutor_answers do |t|
      t.text :answer
      t.datetime :date_published, index: true
      t.boolean :published
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
