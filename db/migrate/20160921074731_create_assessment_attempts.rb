class CreateAssessmentAttempts < ActiveRecord::Migration[6.1]
  def change
    create_table :assessment_attempts do |t|
      t.references :user, index: true, foreign_key: true
      t.references :assessable, polymorphic: true, index: true
      t.float :percentile
      t.integer :mark
      t.datetime :completed_at
      t.timestamps null: false
    end
  end
end
