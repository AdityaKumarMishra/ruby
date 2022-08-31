class CreateEmailCustomises < ActiveRecord::Migration[6.1]
  def change
    create_table :email_customises do |t|
      t.string :product_version
      t.string :course
      t.string :master_feature
      t.boolean :publish
      t.string :email_subject
      t.string :greeting
      t.text :content
      t.string :attachment_name

      t.timestamps null: false
    end
  end
end
