namespace :add_order_date_for_textbook_deliveries do
  task fetch_users: :environment do
    puts "=============== Task Start ==============="
    user_arr = ["adhitig252@gmail.com", "jennacmwood@gmail.com", "racheldonachie91@hotmail.com", "nadiaemsutandar@gmail.com", "graemebautz@gmail.com", "zraza4@icloud.com", "tmoss4344@gmail.com", "ch.aastha866@gmail.com", "emmashaw89@hotmail.com", "caitlinbooker96@hotmail.com", "sahanasughesh@gmail.com", "sarahscott2001@hotmail.com", "emmaj1306@outlook.com"]
    user_arr.each do |email|
      user = User.find_by(email: email)
      if user.present?
        user.enrolments.each do |enrol|
          feature_log = enrol.feature_logs.select{|fl| fl.product_version_feature_price.master_feature_id == 26}.last
          if feature_log.present? && feature_log.acquired.present?
            enrol.update(hardcopy: true)
          end
        end
      end
    end
  end
  puts "=============== Task End ==============="
end
