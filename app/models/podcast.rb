class Podcast < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  has_attached_file :image, styles: { medium: "900x600#", thumb: "300x200>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  def s3_image_url
    number = title.split(':').first.split('.').last.to_i
    return unless number.present?

    "https://gradready.s3.ap-southeast-2.amazonaws.com/podcasts/images/000/000/011/podcast+index+page/#{number}.png"
  end
end