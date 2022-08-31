module OnlineExamAttemptsHelper
  def percentile(exam_test_attempt)
    if exam_test_attempt.section_attempts.completed.count != exam_test_attempt.section_attempts.count
      percentile =  nil
    else
      percentile = exam_test_attempt.percentile
    end
    # percentile.nil? ? 'N/A' : number_to_percentage(percentile, precision: 1)
    percentile.nil? ? 'N/A' : percentile.round(1)
  end

  def hourtominstr(mins)
    mins = mins.to_i
    hours = (mins)/60
    minutes = (mins - hours*60)
    h_str = hours == 1 ? "hour" : "hours"
    min_str = minutes.zero? ? "" : "#{minutes} minutes"
    return "#{hours.to_s} #{h_str} #{min_str}"
  end
end
