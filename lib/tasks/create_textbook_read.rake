namespace :create_textbook_read do
  task fetch_details: :environment do
    puts "===================== Task Start ======================"
    performance_stats = PerformanceStat.where(performable_type: "Textbook")
    performance_stats.each do |ps|
      textbook_read = TextbookRead.find_or_create_by(textbook_id: ps.performable_id, user_id: ps.user_id)
      textbook_read.update(is_read: true)
    end
    puts "====================== Task End ======================="
  end
end
