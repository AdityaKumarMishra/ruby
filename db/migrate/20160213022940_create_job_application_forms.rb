class CreateJobApplicationForms < ActiveRecord::Migration[6.1]
  def change
    create_table :job_application_forms do |t|
      t.string :title
      t.text :description
      t.boolean :open

      t.timestamps null: false
    end
  end
end
