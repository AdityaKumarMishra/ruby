class AddOtherColumnToQuestionnaires < ActiveRecord::Migration[6.1]
  def change
    add_column :questionnaires, :other, :integer
  end
end
