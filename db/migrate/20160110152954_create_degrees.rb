class CreateDegrees < ActiveRecord::Migration[6.1]
  def change
    create_table :degrees do |t|
      t.string :name
      t.string :alternate_name, array: true, default: []
      t.float :atar
      t.string :application_type

      t.timestamps null: false
    end
  end
end
