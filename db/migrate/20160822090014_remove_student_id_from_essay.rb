class RemoveStudentIdFromEssay < ActiveRecord::Migration[6.1]
  def change
  	remove_reference :essays, :student
  end
end
