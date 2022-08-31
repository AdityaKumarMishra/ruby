class FixTypo < ActiveRecord::Migration[6.1]
  def change
    rename_column :course_versions, :expiary_date, :expiry_date
  end
end
