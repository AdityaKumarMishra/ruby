class RemoveEssayExpiryStartDateFromCourse < ActiveRecord::Migration[6.1]
  def change
    remove_column :courses, :essay_exp_start_date
  end
end
