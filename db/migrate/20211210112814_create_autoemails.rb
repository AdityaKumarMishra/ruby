class CreateAutoemails < ActiveRecord::Migration[6.1]
  def change
    create_table :autoemails do |t|
    	t.integer :category
    	t.boolean :is_active, default: false
    	t.text :content
    	t.string :title
    	t.string :greeting
    	t.string :subject
      t.timestamps null: false
    end
  end
end
