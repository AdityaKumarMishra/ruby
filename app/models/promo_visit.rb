class PromoVisit < ApplicationRecord
  scope :previous_week, -> { where('created_at BETWEEN ? AND ?', Time.zone.now.beginning_of_week - 1.week, Time.zone.now.beginning_of_week) }
  scope :this_week, -> { where('created_at > ?', Time.zone.now.beginning_of_week) }
  belongs_to :promo

  # This method returns the number of visits in the previous week
  def self.visit_count_previous_week
    previous_week.count
  end

  # This method returns the number of visits this week
  def self.visit_count_this_week
    this_week.count
  end

  def self.visit_information(scope)
    counts = scope.group(:promo_id).count

    Promo.where(id: counts.keys).map do |promo|
      {
        promo: promo,
        count: counts[promo.id]
      }
    end
  end

  def self.visits_this_week
    visit_information(this_week)
  end

  def self.visits_previous_week
    visit_information(previous_week)
  end
end
