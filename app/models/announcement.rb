# == Schema Information
#
# Table name: Announcement
#
#  id           :integer          not null, primary key
#  name         :string           not null, unique
#  description  :text
#  category     :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  url          :string
#

class Announcement < ApplicationRecord
	validates :name, uniqueness: true
  belongs_to :product_version, optional: true
  has_many :user_announcements, dependent: :destroy
  after_update :update_user_announcements
  after_create :add_product_line
  # after_create :create_user_announcements
  belongs_to :master_feature, optional: true
  belongs_to :product_line, optional: true

  filterrific(
    default_filter_params: {by_product_line: 'All'},
      available_filters: [
          :by_product_line
      ]
  )

  has_attached_file :video, styles: {
    :thumbnail => { :geometry => "192x108#", :format => 'png', :time => 5 }
  }
  validates_attachment_content_type :video, content_type: %w(video/mp4 video/flv video/avi video/wmv video/x-ms-wmv video/mov)

  validates :product_line_id, presence: true, if: Proc.new { |ann| ann.product_line_id.present? }
  validates :master_feature_id, presence: true, if: :validate_master_feature_id

  validates :master_feature_id, uniqueness: { scope: :product_line_id, message: 'This feature is already taken with this product line!' }, if: :validate_master_feature_id

  scope :by_product_line, -> (product_line) { includes(:product_line).where(product_lines: { name: product_line.downcase }) if product_line != "All" }

  def validate_master_feature_id
    Proc.new { |ann| ann.product_line_id.present? } if category != "Homepage" && category != "Dashboardpage"
  end

  def find_feature
    if master_feature.present?
      master_feature.try(:name)
    elsif name.include?("dashboard")
      name.split("Ready").first + "DashboardPage"
    elsif name.include?("Homepage")
      "HomePage"
    else
      name.split("Ready").first + "HomePage"
    end
  end

  def generate_output_path_for(resolution)
    path = video(:"#{resolution}").split('/')[3..-2]
    path << video_file_name
    path.join('/')
  end

  def generate_output_url_for(resolution)
    "https://#{ENV['S3_HOST_ALIAS']}/#{CGI.escape generate_output_path_for(resolution)}"
  end

  private

  def add_product_line
    if self.category == "Homepage" || self.category == "Dashboardpage"
      if name.include?("Gamsat")
        self.product_line_id = 1
        self.save(validate: false)
      elsif name.include?("Umat")
        self.product_line_id = 2
        self.save(validate: false)
      elsif name.include?("Vce")
        self.product_line_id = 3
        self.save(validate: false)
      elsif name.include?("Hsc")
        self.product_line_id = 4
        self.save(validate: false)
      end
    end
  end

  def update_user_announcements
    return unless saved_change_to_description? || saved_change_to_highlighted_text?
    if user_announcements.present? || saved_change_to_highlighted_text?
      user_announcements.update_all(viewed: false)
    end
  end

  def create_user_announcements
    unless self.category == 'Homepage'
      User.student.each do |student|
        user_ann = self.user_announcements.find_or_create_by(user_id: student.id)
        user_ann.update_attribute(:viewed, true)
      end
    end
  end
end
