class ChangeSectionAttemptsDataOfOnlineExamAttemptsToAssessmentAttempt < ActiveRecord::Migration[6.1]
  def up
    q = "SELECT  id, online_exam_id AS assessable_id, 'OnlineExam' AS assessable_type FROM online_exam_attempts;"
    results = ActiveRecord::Base.connection.execute(q)

    results.each do |r|
      ass_atmpt  = AssessmentAttempt.find_by(assessable_id: r['assessable_id'].to_i,
                                      assessable_type: r['assessable_type'])
      SectionAttempt.where(attemptable_id: r['id'].to_i,
                           attemptable_type: "OnlineExamAttempt"
                          ).update_all( attemptable_id: ass_atmpt.id,
                                        attemptable_type: "AssessmentAttempt"
                          ) if ass_atmpt
    end
  end
end
