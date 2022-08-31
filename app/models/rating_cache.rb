class RatingCache < ApplicationRecord
  belongs_to :cacheable, :polymorphic => true
  scope :mcqs_ratings, -> {where cacheable_type: "Mcq" }
end
