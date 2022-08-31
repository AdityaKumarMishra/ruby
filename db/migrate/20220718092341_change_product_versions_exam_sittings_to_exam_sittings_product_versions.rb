class ChangeProductVersionsExamSittingsToExamSittingsProductVersions < ActiveRecord::Migration[6.1]
  def change
    rename_table :product_versions_exam_sittings, :exam_sittings_product_versions
  end
end
