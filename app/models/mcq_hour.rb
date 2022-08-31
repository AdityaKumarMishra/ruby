class McqHour < ApplicationRecord
  filterrific(
    default_filter_params: { },
    available_filters: [
        :with_start,
        :with_end
    ]
  )

  belongs_to :user
  belongs_to :mcq_stem
  enum logging_type: [:author, :reviewer_1, :reviewer_2, :video_explainer, :video_explanation_reviewer]

  validates :hours, :numericality => { :greater_than => 0 }
  validates :logging_type, presence: true

  scope :created_with_start, lambda { |with_start| where('DATE(mcq_hours.created_at) >= ?', with_start.to_date) }
  scope :created_with_end, lambda { |with_end| where('DATE(mcq_hours.created_at) <= ?', with_end.to_date) }
  scope :user_hours, -> (user_id, logging_type){where(user_id: user_id, logging_type: logging_type)}
end