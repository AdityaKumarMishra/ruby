class ChangeTypeOfTimeSubmited < ActiveRecord::Migration[6.1]
  def up
    change_column :essay_responses, :time_submited, :time
  end

  def down
    change_column :essay_responses, :time_submited, :datetime
  end
end
