# == Schema Information
#
# Table name: tutor_profiles
#
#  id             :integer          not null, primary key
#  tutor_id	      :integer
#  private_tutor  :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class TutorProfile < ApplicationRecord
  belongs_to :tutor, class_name: 'User'
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :excluded_taggings, as: :exclude_taggable, class_name: 'Tagging', dependent: :destroy
  has_many :excluded_tags, through: :excluded_taggings, source: 'tag'
  has_many :tutor_availabilities, dependent: :destroy
  has_many :tutor_appointments, through: :tutor
  has_many :tutor_schedules, dependent: :destroy
  accepts_nested_attributes_for :tags, allow_destroy: true
  scope :private_tutor, ->{ where(private_tutor: true )}

  def tags
    tutor.staff_profile.tags
  end

  def excluded_tags
    tutor.staff_profile.excluded_tags
  end

  filterrific(
    default_filter_params: {},
    available_filters: [
      :with_tag,
      :with_location
    ]
  )

  scope :with_tag, ->(tag_ids) { includes(tutor: [staff_profile: :tags]).where(tags: { id: tag_ids })}
  scope :with_location, -> (location) { includes(tutor: :address).where('addresses.state =?', location).references(:users) }

  scope :for_tutor, -> (role) { includes(:tutor).where('users.role IN(?)', role).references(:users) }
end
