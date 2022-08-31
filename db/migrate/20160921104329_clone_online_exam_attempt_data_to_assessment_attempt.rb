class CloneOnlineExamAttemptDataToAssessmentAttempt < ActiveRecord::Migration[6.1]
  def up
    ActiveRecord::Base.connection.execute("INSERT INTO assessment_attempts (
        user_id, assessable_id, assessable_type, percentile, mark, completed_at,
        created_at, updated_at
      )

      SELECT  user_id, online_exam_id AS assessable_id,
      'OnlineExam' AS assessable_type, percentile, mark, completed_at, created_at,
      updated_at FROM online_exam_attempts;"
    ) if ActiveRecord::Base.connection.table_exists? 'online_exam_attempts'
  end
end
