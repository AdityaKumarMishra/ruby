class CreateAccessDocuments < ActiveRecord::Migration[6.1]
  def change
    create_table :access_documents do |t|
      t.datetime :last_accessed
      t.references :document, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
