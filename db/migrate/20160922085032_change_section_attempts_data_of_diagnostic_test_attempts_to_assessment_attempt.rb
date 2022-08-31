class ChangeSectionAttemptsDataOfDiagnosticTestAttemptsToAssessmentAttempt < ActiveRecord::Migration[6.1]
  def up
    q = "SELECT  id, diagnostic_test_id AS assessable_id, 'DiagnosticTest' AS assessable_type FROM diagnostic_test_attempts;"
    results = ActiveRecord::Base.connection.execute(q)

    results.each do |r|
      ass_atmpt  = AssessmentAttempt.find_by(assessable_id: r['assessable_id'].to_i,
                                      assessable_type: r['assessable_type'])
      SectionAttempt.where(attemptable_id: r['id'].to_i,
                           attemptable_type: "DiagnosticTestAttempt"
                          ).update_all( attemptable_id: ass_atmpt.id,
                                        attemptable_type: "AssessmentAttempt"
                          ) if ass_atmpt
    end
  end
end
