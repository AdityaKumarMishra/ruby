class CreateInteractionLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :interaction_logs do |t|
      t.integer :asker_id
      t.integer :answerer_id
      t.string :interaction_type
      t.string :title
      t.text :details
      t.datetime :opened_at
      t.timestamps null: false
    end
  end
end
