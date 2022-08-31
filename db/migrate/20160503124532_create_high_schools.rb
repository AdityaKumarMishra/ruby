class CreateHighSchools < ActiveRecord::Migration[6.1]
  def change
    create_table :high_schools do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
