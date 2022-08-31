namespace :promo do
  task :create_bpromo => :environment do
    b_code = Promo::B_PROMOCODE
    Promo.create(token: b_code, stackable: true, strategy: 0, amount: 25, purchasable_id: nil, purchasable_type: nil, user_id: User.find_by(email: "ts-sa@gradready.com.au").id, used_times: 20, product_version_id: nil, expiry_date: "2019-09-31".to_date) if Promo.find_by(token: b_code).nil?
  end

  task :create_bir_promo => :environment do
    b_code = Promo::B_IR_PROMOCODE
    Promo.create(token: b_code, stackable: true, strategy: 0, amount: 10, purchasable_id: nil, purchasable_type: nil, user_id: User.find_by(email: "ts-sa@gradready.com.au").id, used_times: 20, product_version_id: nil, expiry_date: "2019-09-30".to_date) if Promo.find_by(token: b_code).nil?
  end

  task :update_order_generated_promo_amount => :environment do
    Promo.where.not(generated_from_id: nil).update_all(amount: 10.0)
  end

end
