namespace :update_promo_name do
  puts "======================== TASK START ========================"
  task :fetch_details => :environment do
    Promo.all.update_all(name: "Discount Code")
  end
  puts "======================== TASK END ========================"
end
