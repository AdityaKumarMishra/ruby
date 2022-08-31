class AddNameOpOtherTestScoresToJobApplications < ActiveRecord::Migration[6.1]
  def up
    add_column :job_applications, :name, :string
    add_column :job_applications, :other_test_score, :string
    add_column :job_applications, :applicant_type, :string

    JobApplication.all.each do |job|
      job.update_attribute(:name, "#{job.first_name} #{job.last_name}")
    end
    remove_column :job_applications, :first_name
    remove_column :job_applications, :last_name
  end
  def down
    add_column :job_applications, :first_name, :string
    add_column :job_applications, :last_name, :string
    remove_column :job_applications, :other_test_score
    remove_column :job_applications, :applicant_type

    JobApplication.all.each do |job|
      last_name = job.name.split(" ").last
      first_name = job.name.remove(" #{last_name}")
      job.update_attribute(:first_name, first_name)
      job.update_attribute(:last_name, last_name)
    end
    remove_column :job_applications, :name
  end
end
