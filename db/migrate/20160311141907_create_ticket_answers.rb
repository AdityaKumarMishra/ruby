class CreateTicketAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :ticket_answers do |t|
      t.text :content
      t.references :ticket, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.boolean :public
      t.integer :helpfulness

      t.timestamps null: false
    end
  end
end
