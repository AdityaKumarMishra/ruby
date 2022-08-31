module JobApplicationsHelper
  def is_a_number? text
    true if Float(text) rescue false
  end
end
