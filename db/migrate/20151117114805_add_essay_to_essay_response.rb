class AddEssayToEssayResponse < ActiveRecord::Migration[6.1]
  def change
    add_reference :essay_responses, :essay, index: true, foreign_key: true
  end
end
