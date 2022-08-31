class DestroySubjectIdReferenceToMcqStem < ActiveRecord::Migration[6.1]
  def change
    remove_column :mcq_stems, :subject_id
  end
end
