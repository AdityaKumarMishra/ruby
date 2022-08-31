class AddPromocodeToEnrolments < ActiveRecord::Migration[6.1]
  def change
    add_column :enrolments, :promo, :string
  end
end
