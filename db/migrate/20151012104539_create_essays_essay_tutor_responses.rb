class CreateEssaysEssayTutorResponses < ActiveRecord::Migration[6.1]
  def change
    create_table :essay_tutor_responses do |t|
      t.text :response
      t.decimal :rate, :precision=>10, :scale=>2
      t.references :essay_response, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
