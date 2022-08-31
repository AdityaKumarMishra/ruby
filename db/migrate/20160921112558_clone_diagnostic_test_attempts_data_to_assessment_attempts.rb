class CloneDiagnosticTestAttemptsDataToAssessmentAttempts < ActiveRecord::Migration[6.1]
  def up
    ActiveRecord::Base.connection.execute("INSERT INTO assessment_attempts (
        user_id, assessable_id, assessable_type, percentile, mark, completed_at,
        created_at, updated_at
      )
      SELECT  user_id, diagnostic_test_id AS assessable_id,
      'DiagnosticTest' AS assessable_type, percentile, mark, completed_at,
      created_at, updated_at FROM diagnostic_test_attempts;"
    ) if ActiveRecord::Base.connection.table_exists? 'diagnostic_test_attempts'
  end
end
