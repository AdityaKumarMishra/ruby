class AddSlugToEssayResponses < ActiveRecord::Migration[6.1]
  def change
    add_column :essay_responses, :slug, :string
    add_index :essay_responses, :slug, unique: true
  end
end
