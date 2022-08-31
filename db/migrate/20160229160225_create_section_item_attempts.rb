class CreateSectionItemAttempts < ActiveRecord::Migration[6.1]
  def change
    create_table :section_item_attempts do |t|
      t.references :section_attempt, index: true, foreign_key: true
      t.references :section_item, index: true, foreign_key: true
      t.references :mcq_stem, index: true, foreign_key: true
      t.references :mcq, index: true, foreign_key: true
      t.references :mcq_answer, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
