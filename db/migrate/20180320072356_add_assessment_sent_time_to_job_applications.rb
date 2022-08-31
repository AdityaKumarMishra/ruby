class AddAssessmentSentTimeToJobApplications < ActiveRecord::Migration[6.1]
  def change
    add_column :job_applications, :assessment_sent_time, :datetime
  end
end
