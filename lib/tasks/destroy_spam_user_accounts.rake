namespace :destroy_spam_user_accounts do
  task fetch_users: :environment do
    puts "====================== Task Start ======================"
    ids_arr = []
    User.all.each do |user|
      if user.email.present? && user.email.split(/\s*@\s*/).first.count('.') >= 5
        ids_arr << user.id
      end
    end
    puts "Total User Count: - #{ids_arr.count}"

    ids_arr.in_groups_of(100) do |ids|
      User.where(id: ids).destroy_all
    end
    puts "====================== Task End ======================"
  end
end

