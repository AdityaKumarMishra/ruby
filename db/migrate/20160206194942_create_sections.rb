class CreateSections < ActiveRecord::Migration[6.1]
  def change
    create_table :sections do |t|
      t.string :title
      t.integer :duration
      t.integer :position
      t.references :sectionable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
