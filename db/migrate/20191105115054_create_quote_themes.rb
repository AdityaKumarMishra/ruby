class CreateQuoteThemes < ActiveRecord::Migration[6.1]
  def change
    create_table :quote_themes do |t|
      t.string :theme

      t.timestamps null: false
    end
  end
end
