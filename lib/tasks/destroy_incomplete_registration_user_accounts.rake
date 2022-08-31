namespace :destroy_incomplete_registration_user_accounts do
    task destroy_user: :environment do
      puts "====================== Task Start ======================"
      user_ids = User.where(confirmed_at: nil).pluck(:id)
      user_ids.in_groups_of(500) do |ids|
        User.where(id: ids).destroy_all
        sleep(0.5)
      end
      
      puts "====================== Task End ======================"
    end
  end
  
  