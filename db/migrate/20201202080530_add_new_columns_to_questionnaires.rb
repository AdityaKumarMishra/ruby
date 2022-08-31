class AddNewColumnsToQuestionnaires < ActiveRecord::Migration[6.1]
  def change
    add_column :questionnaires, :designation, :string
    add_column :questionnaires, :learning_institution, :string
    add_column :questionnaires, :year_of_most_recent_completed_qualification, :string
  end
end
