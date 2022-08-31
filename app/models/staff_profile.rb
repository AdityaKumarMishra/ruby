class StaffProfile < ApplicationRecord
  belongs_to :staff, foreign_key: :staff_id, class_name: 'User'

  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings

  has_many :excluded_taggings, as: :exclude_taggable, class_name: 'Tagging', dependent: :destroy
  has_many :excluded_tags, through: :excluded_taggings, source: 'tag'
  has_many :course_staffs, dependent: :destroy
  has_many :courses, through: :course_staffs
  has_many :essay_tutor_responses, :class_name => 'EssayTutorResponse'
  has_many :mock_essay_feedbacks

  accepts_nested_attributes_for :tags, allow_destroy: true
  accepts_nested_attributes_for :excluded_tags, allow_destroy: true

  accepts_nested_attributes_for :courses, allow_destroy: true



  def self.search_descendant_tags(query)

    if query.empty?
      return StaffProfile.none
    else
    staffs=[]
      tokens = query.split(/[ -]/)

      tokens.each do |t|
        staffs = StaffProfile.joins(:staff).where('username like ? OR first_name = ?',"%#{t.downcase}%","%#{t.downcase}%")
      end

      return staffs
    end
  end
end
