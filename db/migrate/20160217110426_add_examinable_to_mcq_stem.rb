class AddExaminableToMcqStem < ActiveRecord::Migration[6.1]
  def change
    add_column :mcq_stems, :examinable, :boolean, default: false
  end
end
