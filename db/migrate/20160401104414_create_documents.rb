class CreateDocuments < ActiveRecord::Migration[6.1]
  def change
    create_table :documents do |t|
      t.boolean :accessible
      t.boolean :allow_dummy
      t.boolean :only_dummy
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
