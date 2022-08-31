class GawController < ApplicationController
  before_action :get_file_path

  def textbook
  end

  def online_exams
  end

  def marked_essays
  end

  def mcq_bank
  end

  def private_tuition_sessions
  end

  def mock_exam
  end

  def online_essentials
  end

  def online_comprehensive
  end

  def attendance_essentials
  end

  def attendance_comprehensive
  end

  def attendance_complete_care
  end


  private

  def get_file_path
    file_name = request.url.split("/").last
    @path = Rails.root.join("public", "images/gaw_shopping_ads", "#{file_name}.png").to_s
    send_file @path, type: 'image/png', disposition: 'inline',stream: 'true'
  end

end
