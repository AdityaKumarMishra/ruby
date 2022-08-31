module OnlineMockExamAttemptsHelper

  def calculate_passed_time start_time, created_time
    ttr = ''
    if start_time < created_time
      total_seconds = created_time - start_time
      toal_hours_float = total_seconds/3600
      toal_hours_int = toal_hours_float.to_i
      hour_diff = toal_hours_float - toal_hours_int
      if hour_diff > 0.0
        minutes_float = hour_diff*60
        minutes_int = minutes_float.to_i
        mint_diff = minutes_float - minutes_int
        if mint_diff > 0.0
          seconds = (mint_diff*60).round(0)
        end
      end
      if toal_hours_int > 0
        h_txt = toal_hours_int > 1 ? "hours" : "hour"
        ttr = "#{ttr} #{toal_hours_int.to_s} #{h_txt}"
      end
      if minutes_int > 0
        min_txt = minutes_int > 1 ? "minutes" : "minute"
        ttr = "#{ttr} #{minutes_int.to_s} #{min_txt}"
      end
      if seconds > 29
        sec_txt = seconds > 1 ? "seconds" : "second"
        ttr = "#{ttr} #{seconds} #{sec_txt}"
      end
    end
    return ttr
  end
end
