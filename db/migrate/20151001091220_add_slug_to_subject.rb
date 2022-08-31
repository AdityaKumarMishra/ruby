class AddSlugToSubject < ActiveRecord::Migration[6.1]
  def change
    add_column :subjects, :slug, :string
    add_index :subjects, :slug, unique: true
  end
end
