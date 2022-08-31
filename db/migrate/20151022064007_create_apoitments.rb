class CreateApoitments < ActiveRecord::Migration[6.1]
  def change
    create_table :apoitments do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.references :student, index: true
      t.references :tutor, index: true

      t.timestamps null: false
    end
  end
end