class CreateDiagnosticTest < ActiveRecord::Migration[6.1]
  def change
    create_table :diagnostic_tests do |t|
      t.string :title
      t.text :instruction
      t.boolean :published

      t.timestamps null: false
    end
  end
end
