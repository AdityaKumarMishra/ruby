namespace :update_TB_status_to_sent do
  task update_status: :environment do
    puts "====================== Task Start ======================"
    ids= [107921, 108062, 108013, 103405,90558 , 42867, 88890, 107070, 107899, 106803, 10401, 107745,107879, 107837, 107749,107805, 107797, 107764, 52285, 101102, 107732, 107705, 107706, 107637, 107674, 107154, 107613, 105134, 107576, 107578, 107538, 107503, 89014, 34050,107325, 105532, 107251, 105643,104986, 107173, 1550, 107132, 107111, 104450, 107091, 100720, 107057, 107044, 106524, 104907, 19147, 106483,4032,106853,5860,106246,13301,12492]
    ids.each do |id|
      user= User.find_by(id: id)
      tb=user.try(:textbook_deliveries).last
      if (tb.try(:date_sent).present? || tb.try(:tracking_number).present?)
        tb.status = "Sent"
        tb.save
      end
    end
      
    puts "====================== Task End ======================"
  end
end
  
  
