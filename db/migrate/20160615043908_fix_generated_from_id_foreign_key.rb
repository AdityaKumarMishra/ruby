class FixGeneratedFromIdForeignKey < ActiveRecord::Migration[6.1]
  def up
    remove_foreign_key "promos", column: "generated_from_id"
    add_foreign_key "promos", "orders", column: "generated_from_id"
  end

  def down
    remove_foreign_key "promos", column: "generated_from_id"
    add_foreign_key "promos", "users", column: "generated_from_id"
  end
end
