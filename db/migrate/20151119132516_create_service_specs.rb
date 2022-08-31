class CreateServiceSpecs < ActiveRecord::Migration[6.1]
  def change
    create_table :service_specs do |t|
      t.references :invoice_spec, index: true, foreign_key: true
      t.references :exam, index: true, foreign_key: true
      t.references :essay, index: true, foreign_key: true
      t.references :mcq, index: true, foreign_key: true
      t.references :apoitment, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
