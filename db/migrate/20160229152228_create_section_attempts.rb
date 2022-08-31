class CreateSectionAttempts < ActiveRecord::Migration[6.1]
  def change
    create_table :section_attempts do |t|
      t.float :percentile
      t.integer :mark
      t.datetime :completed_at
      t.references :attemptable, polymorphic: true, index: true
      t.references :section, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
