class AddDiagnosticToMcq < ActiveRecord::Migration[6.1]
  def change
    add_column :mcqs, :diagnostic, :boolean
  end
end
