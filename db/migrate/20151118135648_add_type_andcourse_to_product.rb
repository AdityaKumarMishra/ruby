class AddTypeAndcourseToProduct < ActiveRecord::Migration[6.1]
  def change
    add_reference :products, :product_type, index: true, foreign_key: true
    add_reference :products, :course, index: true, foreign_key: true
  end
end
