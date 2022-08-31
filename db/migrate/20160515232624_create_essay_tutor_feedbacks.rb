class CreateEssayTutorFeedbacks < ActiveRecord::Migration[6.1]
  def change
    create_table :essay_tutor_feedbacks do |t|
      t.references :staff_profile, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.decimal :rate
      t.text :response

      t.timestamps null: false
    end
  end
end
