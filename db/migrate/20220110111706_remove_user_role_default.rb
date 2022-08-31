class RemoveUserRoleDefault < ActiveRecord::Migration[6.1]
  def up
    change_column_default(:users, :role, nil)
  end

  def down
    change_column_default(:users, :role, 0)
  end
end
