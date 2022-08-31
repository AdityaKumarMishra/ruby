class CreateOnlineExamTemplates < ActiveRecord::Migration[6.1]
  def change
    create_table :online_exam_templates do |t|
      t.string :name
      t.timestamps
    end
  end
end
