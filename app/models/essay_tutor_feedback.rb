class EssayTutorFeedback < ApplicationRecord
  belongs_to :essay_response
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  include EditorParsable
  after_commit :check_rating, if: :persisted?
  after_create :inform_tutor

  def check_rating
    if rating.to_i <= 60
      EssayTutorMailer.low_tutor_mark(self.essay_response, essay_response.essay_tutor_response.staff_profile).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false"
    end
  end

  def inform_tutor
    EssayTutorMailer.inform_tutor(self.essay_response, essay_response.essay_tutor_response.staff_profile).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false"
  end
end
