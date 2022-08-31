class OnlineMockVod < ApplicationRecord
  belongs_to :online_mock_exam
  has_attached_file :video
  validates_attachment_content_type :video, content_type: %w(video/mp4 video/flv video/avi video/wmv video/x-ms-wmv video/mov)

  def generate_output_path_for(resolution)
    path = video(:"#{resolution}").split('/')[3..-2]
    path << video_file_name
    path.join('/')
  end

  def generate_output_url_for(resolution)
    "https://#{ENV['S3_HOST_ALIAS']}/#{CGI.escape generate_output_path_for(resolution)}"
  end

  def active?
    self.try(:active)
  end

  def show_countdown?
    self.try(:active?) && self.try(:valid_countdown)
  end


end
