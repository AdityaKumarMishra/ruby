namespace :add_countdown_timers do
  task add_countdown_timers: :environment do
    ["GAMSAT", "UMAT", "Home"].each do |pt|
      CountdownTimer.create(title: "#{pt} Countdown Timer", description: "The next course closure is in", end_date: Time.zone.now.to_date, end_time: Time.zone.now.end_of_day, page_type: CountdownTimer.page_types[pt], active: false) if CountdownTimer.find_by(page_type: CountdownTimer.page_types[pt]).nil?
    end
  end
end
