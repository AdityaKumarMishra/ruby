class CreateCitiesExamSittings < ActiveRecord::Migration[6.1]
  def change
    create_table :cities_exam_sittings do |t|
      t.integer :city_id
      t.integer :exam_sitting_id
      t.timestamps
    end
  end
end
