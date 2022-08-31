class AddBanktransToEnrolments < ActiveRecord::Migration[6.1]
  def change
    add_column :enrolments, :banktrans, :string
  end
end
