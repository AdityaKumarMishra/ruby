class AddPositionToOnlineExam < ActiveRecord::Migration[6.1]
  def change
    add_column :online_exams, :position, :integer
  end
end
