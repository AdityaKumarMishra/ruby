class AddIndexToSubject < ActiveRecord::Migration[6.1]
  def change
    add_index :subjects, :title
  end
end
