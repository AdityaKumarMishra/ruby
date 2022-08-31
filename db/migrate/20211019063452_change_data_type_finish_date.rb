class ChangeDataTypeFinishDate < ActiveRecord::Migration[6.1]
  def change
  	change_column :appointment_hours, :finish_date, :date
  end
end
