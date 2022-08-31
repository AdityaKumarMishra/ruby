# == Schema Information
#
# Table name: video_categories
#
#  id         :integer          not null, primary key
#  name       :string
#  subject_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class VideoCategory < ApplicationRecord
  belongs_to :subject
  has_many :vods

  validates_presence_of :name,:subject_id

  def self.options_for_select
    order('LOWER(name)').map { |e| [e.name, e.id] }
  end

  def to_s
    name
  end

end
