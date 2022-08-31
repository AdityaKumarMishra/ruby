class DropTableDiagnosticTestAttempts < ActiveRecord::Migration[6.1]
  def change
    drop_table :diagnostic_test_attempts
  end
end
