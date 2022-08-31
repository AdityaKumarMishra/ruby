namespace :split_users_name do
  task first_name_last_name: :environment do
    puts "=============== Task Start ==============="
    users = User.all
    users.each do |user|
      if user.first_name.present?
        f_name = user.first_name.partition(" ").first.try(:capitalize)
        l_name = ""
        if user.last_name.present?
          l_name = (user.last_name + " " + user.first_name.partition(" ").last.try(:titleize)).strip
        else
          l_name = user.first_name.partition(" ").last.try(:titleize)
        end
        user.update(first_name: f_name, last_name: l_name )
      end
    end
    puts "=============== Task End ==============="
  end
end
