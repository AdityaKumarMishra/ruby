class CreateExams < ActiveRecord::Migration[6.1]
  def change
    create_table :exams do |t|
      t.datetime :date_started
      t.datetime :date_finished
      t.string :type

      t.timestamps null: false
    end
  end
end
