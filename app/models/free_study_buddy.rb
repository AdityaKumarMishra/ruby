class FreeStudyBuddy < ApplicationRecord
  enum service_type: [:free_study_buddy, :free_study_guide, :free_gamsat_trial]
  before_save :set_active

  def self.by_service_type(service_type)
    find_by(service_type: service_type)
  end

  def is_active?
    self.active
  end

  private
  def set_active
	  FreeStudyBuddy.where.not(id: id).update_all(active: false)
  end
end
