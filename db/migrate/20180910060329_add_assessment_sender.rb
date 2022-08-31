class AddAssessmentSender < ActiveRecord::Migration[6.1]
  def change
    add_column :job_applications, :assessment_sender_id, :integer
  end
end
