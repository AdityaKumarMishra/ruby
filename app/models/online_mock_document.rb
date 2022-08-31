class OnlineMockDocument < ApplicationRecord
  belongs_to :online_mock_exam
  has_attached_file :document, path: APP_CONFIG[:paperclip_path],
                               url: APP_CONFIG[:paperclip_url]
  validates :document, presence: true
  validates_attachment_content_type :document, content_type: 'application/pdf'

  def full_url
    Rails.application.routes.url_helpers.url_for controller: 'online_mock_exam_attempts', action: 'download', id: self.id, only_path: true
  end

  def document_start_time
    start_date = self.start_date.to_s
    start_time = self.start_time.strftime("%H:%M%P")
    return ActiveSupport::TimeZone['Australia/Melbourne'].parse([start_date, start_time].join(' '))
  end

  def document_end_time
    end_date = self.end_date.to_s
    end_time = self.end_time.strftime("%H:%M%P")
    return ActiveSupport::TimeZone['Australia/Melbourne'].parse([end_date, end_time].join(' '))
  end

end
