class AddRatingToMcq < ActiveRecord::Migration[6.1]
  def change
    add_column :mcqs, :rating, :float
  end
end
