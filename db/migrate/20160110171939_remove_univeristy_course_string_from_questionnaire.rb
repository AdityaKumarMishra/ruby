class RemoveUniveristyCourseStringFromQuestionnaire < ActiveRecord::Migration[6.1]
  def change
    remove_column :questionnaires, :university
    remove_column :questionnaires, :course
  end
end
