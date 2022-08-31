class AddDetailsToJobApplications < ActiveRecord::Migration[6.1]
  def change
    add_column :job_applications, :hours_available, :string
    add_column :job_applications, :domestic, :boolean
    add_column :job_applications, :degree_type, :string
    add_column :job_applications, :degree, :string
    add_column :job_applications, :atar, :string
    add_column :job_applications, :wam, :string
    add_column :job_applications, :graduation, :string
    add_column :job_applications, :status, :string
    add_column :job_applications, :notes, :text
  end
end
