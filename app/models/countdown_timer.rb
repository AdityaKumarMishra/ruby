class CountdownTimer < ApplicationRecord
  enum page_type: ["GAMSAT", "UMAT", "Home"]

  def self.by_page_type(page_type)
    find_by(page_type: page_type)
  end

  def valid_countdown
    date = self.try(:end_date).to_s
    time = self.try(:end_time).strftime("%H:%M%P")
    camparable_time = ActiveSupport::TimeZone['Australia/Melbourne'].parse([date, time].join(' '))
    return camparable_time > Time.zone.now ? true : false
  end

  def active?
    self.try(:active)
  end

  def show_countdown?
    self.try(:active?) && self.try(:valid_countdown)
  end
end
