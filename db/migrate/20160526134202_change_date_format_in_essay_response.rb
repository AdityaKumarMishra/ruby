class ChangeDateFormatInEssayResponse < ActiveRecord::Migration[6.1]
  def up
    remove_column :essay_responses, :time_submited
    add_column :essay_responses, :time_submited, :datetime
  end

  def down
    remove_column :essay_responses, :time_submited
    add_column :essay_responses, :time_submited, :time
  end
end


