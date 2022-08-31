class AddSlugToJobApplicationForm < ActiveRecord::Migration[6.1]
  def change
    add_column :job_application_forms, :slug, :string
    add_index :job_application_forms, :slug, unique: true
    JobApplicationForm.all.map(&:save)
  end
end
