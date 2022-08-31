class CreateEssaysEssayResponses < ActiveRecord::Migration[6.1]
  def change
    create_table :essay_responses do |t|
      t.text :response
      t.datetime :time_submited
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_reference :essays, :essay_response, index: true, foreign_key: true
  end
end
