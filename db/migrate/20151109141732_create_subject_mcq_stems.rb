class CreateSubjectMcqStems < ActiveRecord::Migration[6.1]
  def change
    create_table :subject_mcq_stems do |t|
      t.references :subject, index: true, foreign_key: true
      t.references :mcq_stem, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
