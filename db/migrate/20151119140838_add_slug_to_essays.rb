class AddSlugToEssays < ActiveRecord::Migration[6.1]
  def change
    add_column :essays, :slug, :string
    add_index :essays, :slug, unique: true
  end
end
