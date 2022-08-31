class CreateJobDescriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :job_descriptions do |t|
      t.integer :job_application_form_id

      t.timestamps null: false
    end
  end
end
