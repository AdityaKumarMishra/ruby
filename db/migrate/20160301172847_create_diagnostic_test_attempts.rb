class CreateDiagnosticTestAttempts < ActiveRecord::Migration[6.1]
  def change
    create_table :diagnostic_test_attempts do |t|
      t.references :user, index: true, foreign_key: true
      t.references :diagnostic_test, index: true, foreign_key: true
      t.integer :mark
      t.float :percentile
      t.datetime :completed_at

      t.timestamps null: false
    end
  end
end
