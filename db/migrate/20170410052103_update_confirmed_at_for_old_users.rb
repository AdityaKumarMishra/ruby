class UpdateConfirmedAtForOldUsers < ActiveRecord::Migration[6.1]
  def change
    execute("UPDATE users SET confirmed_at = NOW()")
  end
end
