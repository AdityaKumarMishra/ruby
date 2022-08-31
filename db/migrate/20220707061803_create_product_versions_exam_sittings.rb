class CreateProductVersionsExamSittings < ActiveRecord::Migration[6.1]
  def change
    create_table :product_versions_exam_sittings do |t|
      t.integer :product_version_id
      t.integer :exam_sitting_id
      t.timestamps
    end
  end
end
