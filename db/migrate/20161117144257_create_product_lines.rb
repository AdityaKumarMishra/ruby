class CreateProductLines < ActiveRecord::Migration[6.1]
  def self.up
    create_table :product_lines do |t|
      t.string :name

      t.timestamps null: false
    end

    %w(gamsat umat vce hsc).each do |product_line|
      ProductLine.create(name: product_line)
    end
  end

  def self.down
    drop_table :product_lines
  end
end
