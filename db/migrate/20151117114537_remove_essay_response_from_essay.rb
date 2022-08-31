class RemoveEssayResponseFromEssay < ActiveRecord::Migration[6.1]
  def change
    remove_column :essays, :essay_response_id
  end
end
