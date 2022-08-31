class UserStat < ApplicationRecord
  belongs_to :user
  belongs_to :tag
  belongs_to :viewable, polymorphic: true, optional: true
  validates :user_id, :tag_id, presence: true

  scope :viewable_type, -> (type) { where(viewable_type: type ) }
end
