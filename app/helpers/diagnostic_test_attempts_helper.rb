module DiagnosticTestAttemptsHelper
  def percentile(diagnostic_test_attempt)
    if diagnostic_test_attempt.section_attempts.completed.count == 1
      percentile =  diagnostic_test_attempt.section_attempts.completed.first.percentile
    else
      percentile = diagnostic_test_attempt.percentile
    end
    percentile.nil? ? 'N/A' : number_to_percentage(percentile, precision: 1)
  end
end
