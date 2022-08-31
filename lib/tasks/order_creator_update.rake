namespace :order do
  desc 'Set creator for past orders'
  task :set_creator_for_past_orders => :environment do
    Order.all.each do |order|
      if order.creator.blank? && order.status=="free"
        if order.update!(creator_id: User.superadmin.first.id)
          puts("Success")
        else
          puts("failed")
        end
      end
    end
  end
end