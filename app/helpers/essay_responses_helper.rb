module EssayResponsesHelper
  def display_time(milliseconds)
    Time.at(milliseconds/1000).utc.strftime("%H:%M:%S")

  end

  def grouped_by_week_by_sp_id(essay_responses, sps)
    weekly_hash = {}

    sps.each do |sp|
      staff_essay_responses = essay_responses.where(staff_profiles: {id: sp.last})

      staff_essay_responses.each do |essay_response|
        weekday = essay_response.expiry_date.strftime('%w')

        if weekday == '1'
          day, month = essay_response.expiry_date.in_time_zone("Australia/Melbourne").strftime('%d %m').split(' ')
          week_str = "(#{essay_response.expiry_date.strftime('%Y')}) #{month}#{day}"
        elsif weekday == '0'
          day, month = (essay_response.expiry_date - 6.days).in_time_zone("Australia/Melbourne").strftime('%d %m').split(' ')
          week_str = "(#{essay_response.expiry_date.strftime('%Y')}) #{month}#{day}"
        else
          day, month = (essay_response.expiry_date - (weekday.to_i - 1).days).in_time_zone("Australia/Melbourne").strftime('%d %m').split(' ')
          week_str = "(#{essay_response.expiry_date.strftime('%Y')}) #{month}#{day}"
        end

        weekly_hash[week_str] = {} if weekly_hash[week_str].nil?
        weekly_hash[week_str][sp.last.to_s] = weekly_hash[week_str][sp.last.to_s].to_i + 1
      end
    end

    weekly_hash
  end

  def marked_essays_pay_period
    pay_base = marked_essays_pay_period_base
    pay_periods = []

    # show last 5 and next 10 pay periods
    pay_period_end = 0
    pay_period_start = -25

    (pay_period_start..pay_period_end).each do |i|
      pay_periods.push(["#{pay_base[0] + (i * 14)} - #{pay_base[1] + (i * 14)}"])
    end
    pay_periods
  end

  #def get_weekly_dates(essay_responses)
    #essay_responses.each do |e_r|
    #a= e_r.created_at.group_by{}

    #end
    
  #end

  def marked_essays_pay_period_base
    start_date = Time.zone.today
    fix_start_date = Date.parse("04/09/2017")
    diff = (start_date.to_date - fix_start_date).to_i
    remain = diff % 14
    add_to = diff - remain
    initial_start_date = fix_start_date + add_to
    p1_start = initial_start_date
    p1_end = p1_start + 13
    [p1_start, p1_end]
  end
end  
