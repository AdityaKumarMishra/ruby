class CreateMockEssayFeedbacks < ActiveRecord::Migration[6.1]
  def change
    create_table :mock_essay_feedbacks do |t|

      t.references :user, index: true, foreign_key: true
      t.references :mock_essay, index: true, foreign_key: true
      t.decimal :rating
      t.text :response

      t.timestamps null: false
    end
  end
end
