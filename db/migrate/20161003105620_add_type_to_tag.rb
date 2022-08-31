class AddTypeToTag < ActiveRecord::Migration[6.1]
  def change
    add_column :tags, :type_name, :string, default: 'Tag'
  end
end
