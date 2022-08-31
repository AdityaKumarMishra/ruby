class CreatePromoVisits < ActiveRecord::Migration[6.1]
  def change
    create_table :promo_visits do |t|
      t.references :promo, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
