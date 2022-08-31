class RemoveTimeTakenFromMcqAnswer < ActiveRecord::Migration[6.1]
  def change
    remove_column :mcq_answers, :time_taken
  end
end
