class CreateTextbooks < ActiveRecord::Migration[6.1]
    def change
        create_table :textbooks do |t|
          t.string :title
          t.attachment :document
    
          t.timestamps null: false
        end
    end
end