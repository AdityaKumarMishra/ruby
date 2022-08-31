class TextbookUrl < ApplicationRecord

  belongs_to :textbook
  belongs_to :user

  def full_url
    # The PDF URL is another rails controller
    Rails.application.routes.url_helpers.url_for controller: 'textbook_url', action: 'download', id: self.id, only_path: true
  end
end
