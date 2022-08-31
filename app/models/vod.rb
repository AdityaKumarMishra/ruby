# == Schema Information
#
# Table name: vods
#
#  id                 :integer          not null, primary key
#  title              :string
#  date_published     :datetime
#  published          :boolean
#  viewcount          :integer
#  video_file_name    :string
#  video_content_type :string
#  video_file_size    :integer
#  video_updated_at   :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  subject_id         :integer
#  video_category_id  :integer
#

class Vod < ApplicationRecord
  before_create :reset_viewcount
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :tickets, as: :questionable
  has_many :watcheds, dependent: :destroy
  has_many :performance_stats, as: :performable
  has_many :user_stats, as: :viewable

  accepts_nested_attributes_for :taggings

  validates_presence_of :title, :video, :date_published, :description

  ##Added for GRAD-3481
  validate :validate_work_directory

  has_attached_file :video, styles: {
    :thumbnail => { :geometry => "192x108#", :format => 'png', :time => 5 }
  }
  # has_attached_file :video, styles: {
  #   :thumb => ["100x100#", :png]
  # }
  after_commit :create_transcoding_worker, on: [:create, :update]
  validates_attachment_content_type :video, content_type: %w(video/mp4 video/flv video/avi video/wmv video/x-ms-wmv video/mov)

  ratyrate_rateable

  scope :by_product_line, -> (product_line) {
    vod_tags_ids = Tag.by_product_line(product_line).map(&:id)
    Tag.includes(:taggings).where('tags.id IN (?) AND taggings.taggable_id IN (?) AND taggings.taggable_type=? ', vod_tags_ids, Vod.all.ids,'Vod').references(:taggings).collect(&:second_sub_root).uniq.compact.sort_by(&:name) }

  scope :by_level2_tag, -> (tag_id) {
    if tag_id.present?
      vod_tags_ids = Tag.find(tag_id).self_and_descendants_ids
      Tag.includes(:taggings).where('tags.id IN (?) AND taggings.taggable_id IN (?) AND taggings.taggable_type=? ', vod_tags_ids, Vod.all.ids,'Vod').references(:taggings)
    else
      Tag.none
    end
  }

  scope :by_tag_id, -> (tag_id) {
    if tag_id.present?
      vod_tags_ids = Tag.find(tag_id).self_and_descendants_ids
      Tag.includes(:taggings).where('tags.id IN (?) AND taggings.taggable_id IN (?) AND taggings.taggable_type=? ', vod_tags_ids, Vod.all.ids,'Vod').references(:taggings)
    else
      Tag.none
    end
  }

  scope :by_tag, -> (tag_id) { includes(:taggings).where(taggings: { tag_id: tag_id }) }
  scope :by_parent_tag, -> (tag) {includes(:tags).where(tags: {parent: tag})}
  scope :by_decendent_tag, -> (tag) { includes(:taggings, :tags).where(taggings: { tag_id: tag.self_and_descendants }) }


  def generate_output_path_for(resolution)
    path = video(:"#{resolution}").split('/')[3..-2]
    path << video_file_name
    path.join('/')
  end

  def generate_output_url_for(resolution)
    "https://#{ENV['S3_HOST_ALIAS']}/#{CGI.escape generate_output_path_for(resolution)}"
  end

  def generate_thumbnail_url
    path = video(:thumbnail).split('/')[3..-2]
    path << 'thumbnail-00002.png'
    path = path.join('/')
    url = "https://#{ENV['S3_HOST_ALIAS']}/#{path}"
    return check_if_thumbnail_exists(url) ? url : regenerate_thumbnail_url
  end

  def generate_thumbnail_path
    path = video(:thumbnail).split('/')[3..-2]
    path << 'thumbnail-{count}'
    path.join('/')
  end

  def self.by_tags(mcq_tag_id)
    self.includes(:tags).where("tags.id =?", mcq_tag_id).references(:tags)
  end

  def name_human
    "Video"
  end

  private

  def create_transcoding_worker
    if  previous_changes[:video_file_name].present? || previous_changes[:video_file_size].present? || previous_changes[:video_updated_at].present?
      video_path = video.path
      video_path.slice!(0)
      elastictranscoder = Aws::ElasticTranscoder::Client.new(region: ENV['AWS_REGION'])
      elastictranscoder.create_job(
        pipeline_id: ENV['AWS_PIPELINE_ID'],
        input: {
          key: video_path
        },
        outputs: [
          {
            key: generate_output_path_for('720p'),
            thumbnail_pattern: generate_thumbnail_path,
            preset_id: '1351620000001-000010' # 720p
          },
          {
            key: generate_output_path_for('360p'),
            preset_id: '1351620000001-000040' # 360p

          }
        ]
      )
    end
  end

  def check_if_thumbnail_exists(url)
    uri = URI(url)
    request = Net::HTTP.new uri.host
    response = request.request_head uri.path
    return response.code.to_i == 200
  end

  def regenerate_thumbnail_url
    path = video(:thumbnail).split('/')[3..-2]
    path << 'thumbnail-00001.png'
    path = path.join('/')
    "https://#{ENV['S3_HOST_ALIAS']}/#{path}"
  end

  def reset_viewcount
    self.viewcount = 0
  end
end
