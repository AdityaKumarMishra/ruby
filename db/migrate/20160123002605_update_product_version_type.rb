class UpdateProductVersionType < ActiveRecord::Migration[6.1]
  def up
    umat_product_verions = ProductVersion.where(type: 'Umatready')
    umat_product_verions.update_all(type: 'UmatReady')
  end

  def down
    umat_product_verions = ProductVersion.where(type: 'UmatReady')
    umat_product_verions.update_all(type: 'Umatready')
  end
end
