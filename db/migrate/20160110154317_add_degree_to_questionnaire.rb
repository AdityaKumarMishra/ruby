class AddDegreeToQuestionnaire < ActiveRecord::Migration[6.1]
  def change
    add_reference :questionnaires, :degree, index: true, foreign_key: true
  end
end
