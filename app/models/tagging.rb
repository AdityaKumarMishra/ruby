class Tagging < ApplicationRecord
  belongs_to :tag
  belongs_to :taggable, polymorphic: true
  belongs_to :exclude_taggable, polymorphic: true, optional: true

  validates :tag, presence: true
  # validates taggable presence will fail nested attributes
end
