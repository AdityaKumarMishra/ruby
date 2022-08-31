class AddFinishDisagnosticFieldToDiagnosticTest < ActiveRecord::Migration[6.1]
  def change
    add_column :diagnostic_tests, :is_finish, :boolean, default: false
  end
end
