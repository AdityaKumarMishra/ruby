class AddShowStatsToOnlineExam < ActiveRecord::Migration[6.1]
  def up
    add_column :online_exams, :show_stat, :boolean, default: false
    add_column :diagnostic_tests, :show_stat, :boolean, default: false
  end

  def down
    remove_column :online_exams, :show_stat
    remove_column :diagnostic_tests, :show_stat
  end
end
