class CreateResumes < ActiveRecord::Migration[6.1]
  def change
    create_table :resumes do |t|
      t.integer :job_application_id

      t.timestamps null: false
    end
  end
end
