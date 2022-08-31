class AddEssayExpiryStartDateToCourse < ActiveRecord::Migration[6.1]
  def up
    add_column :courses, :essay_exp_start_date, :date
    courses = Course.all
    courses.update_all(essay_exp_start_date: Date.today.beginning_of_year)
  end
  def down
    remove_column :courses, :essay_exp_start_date
  end
end
