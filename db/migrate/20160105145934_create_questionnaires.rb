class CreateQuestionnaires < ActiveRecord::Migration[6.1]
  def change
    create_table :questionnaires do |t|
      t.string :university
      t.string :course
      t.string :year
      t.boolean :umat_high_school
      t.boolean :umat_uni
      t.text :source, array: true, default: []
      t.text :last_source
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
