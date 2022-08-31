class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :user, uniqueness: { scope: :votable, message: 'aleady voted.' }
end
