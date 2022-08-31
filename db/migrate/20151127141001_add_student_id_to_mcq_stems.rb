class AddStudentIdToMcqStems < ActiveRecord::Migration[6.1]
  def change
    add_reference :mcq_stems, :student, index: true
  end
end
