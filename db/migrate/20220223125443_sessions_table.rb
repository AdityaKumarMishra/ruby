class SessionsTable < ActiveRecord::Migration[6.1]
  def change
    drop_table(:sessions, if_exists: true)
  end
end
