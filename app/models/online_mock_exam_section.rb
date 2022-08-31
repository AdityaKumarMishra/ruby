class OnlineMockExamSection < ApplicationRecord
	belongs_to :essay, optional: true
  belongs_to :online_exam, optional: true
  belongs_to :online_mock_exam, optional: true
  enum section_type: [:video, :document, :online_exam, :essay]
	has_attached_file :document, path: APP_CONFIG[:paperclip_path],
	                           url: APP_CONFIG[:paperclip_url]
  validates_attachment_content_type :document, content_type: 'application/pdf'
  has_attached_file :video
  validates_attachment_content_type :video, content_type: %w(video/mp4 video/flv video/avi video/wmv video/x-ms-wmv video/mov)
  # attr_accessor :essay_title1, :essay_question1, :tag1, :essay_title2, :essay_question2, :tag2, :staff_id2, :essay_expire_time2

  def generate_output_path_for(resolution)
    path = video(:"#{resolution}").split('/')[3..-2]
    path << video_file_name
    path.join('/')
  end

  def generate_output_url_for(resolution)
    "https://#{ENV['S3_HOST_ALIAS']}/#{CGI.escape generate_output_path_for(resolution)}"
  end

  def full_url
    Rails.application.routes.url_helpers.url_for controller: 'online_mock_exam_attempts', action: 'download', id: self.id, only_path: true
  end

  def omes_document_start_time
    start_date = self.start_date.to_s
    start_time = self.start_time.strftime("%H:%M%P")
    return ActiveSupport::TimeZone[self.online_mock_exam.city.gsub("Sept-GAMSAT ","").gsub("Other","Melbourne")].parse([start_date, start_time].join(' '))
  end

  def omes_document_end_time
    end_date = self.end_date.to_s
    end_time = self.end_time.strftime("%H:%M%P")
    return ActiveSupport::TimeZone[self.online_mock_exam.city.gsub("Sept-GAMSAT ","").gsub("Other","Melbourne")].parse([end_date, end_time].join(' '))
  end
end
