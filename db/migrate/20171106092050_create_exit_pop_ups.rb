class CreateExitPopUps < ActiveRecord::Migration[6.1]
  def change
    create_table :exit_pop_ups do |t|
      t.string     :display_name
      t.text       :message
      t.string     :url
      t.boolean    :visible_to_user, default: false
      t.string     :btn_text,     limit: 20
      t.string     :btn_url
      t.string     :category
      t.references :product_line, foreign_key: true

      t.timestamps null: false
    end
  end
end
