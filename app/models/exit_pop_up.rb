class ExitPopUp < ApplicationRecord

  validates :display_name, :message, :category, :btn_text, :btn_url, :cookie_name, presence: true
  validates :btn_text, length: { maximum: 20 }

end
