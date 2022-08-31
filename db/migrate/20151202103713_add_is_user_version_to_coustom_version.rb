class AddIsUserVersionToCoustomVersion < ActiveRecord::Migration[6.1]
  def change
    add_column :course_versions, :is_user_version, :boolean
  end
end
