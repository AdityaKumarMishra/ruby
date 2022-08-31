class AddNewFieldToJobApplications < ActiveRecord::Migration[6.1]
  def change
    add_column :job_applications, :interview_date, :datetime
  end
end
