class AddExamToEssay < ActiveRecord::Migration[6.1]
  def change
    add_reference :essays, :exam, index: true, foreign_key: true
  end
end
