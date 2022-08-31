class CreateCoverLetters < ActiveRecord::Migration[6.1]
  def change
    create_table :cover_letters do |t|
      t.integer :job_application_id

      t.timestamps null: false
    end
  end
end
