class CreateSectionItems < ActiveRecord::Migration[6.1]
  def change
    create_table :section_items do |t|
      t.references :section, index: true, foreign_key: true
      t.references :mcq_stem, index: true, foreign_key: true
      t.references :mcq, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
