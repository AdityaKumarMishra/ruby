namespace :destroy_product_version_feature_price do
  task destroy_pvfp: :environment do
    puts "====================== Task Start ======================"
    temp_arr = [0, -1, -2, -3, -4, -5, -6, -7, -8, -9, -10]
    ProductVersionFeaturePrice.where(qty: temp_arr).destroy_all
    puts "====================== Task End ======================"
  end
end
