class AddNewColsToJobApplications < ActiveRecord::Migration[6.1]
  def change
    add_column :job_applications, :gr_score, :string
    add_column :job_applications, :full_time_exp, :string
  end
end
