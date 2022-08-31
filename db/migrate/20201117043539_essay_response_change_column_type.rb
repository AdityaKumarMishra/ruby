class EssayResponseChangeColumnType < ActiveRecord::Migration[6.1]
  def change
  	change_column(:essay_responses, :expiry_date, :datetime)
  end
end
