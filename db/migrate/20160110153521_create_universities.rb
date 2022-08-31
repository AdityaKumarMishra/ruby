class CreateUniversities < ActiveRecord::Migration[6.1]
  def change
    create_table :universities do |t|
      t.string :name
      t.string :alternate_name
      t.string :location

      t.timestamps null: false
    end
  end
end
