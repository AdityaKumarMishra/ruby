class AddDiagnosticToMcqStem < ActiveRecord::Migration[6.1]
  def change
    add_column :mcq_stems, :diagnostic, :boolean
  end
end
