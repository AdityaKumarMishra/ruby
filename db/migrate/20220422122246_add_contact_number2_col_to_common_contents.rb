class AddContactNumber2ColToCommonContents < ActiveRecord::Migration[6.1]
  def change
    add_column :common_contents, :contact_number2, :string
  end
end
