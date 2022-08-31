class AddEssayNumToFeature < ActiveRecord::Migration[6.1]
  def change
    add_column :features, :essay_num, :integer
  end
end
