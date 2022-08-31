class CreateQuoteBanks < ActiveRecord::Migration[6.1]
  def change
    create_table :quote_banks do |t|
      t.string :quote
      t.string :author
      t.references :quote_theme, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
