class AddInstitutionNameToArea < ActiveRecord::Migration[6.1]
  def change
    add_column :areas, :institution_name, :string
  end
end
