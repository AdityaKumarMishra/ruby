module OnlineMockExamsHelper
  def city_time(date, time)
    case self.city
    when "Sept-GAMSAT Melbourne"
      ActiveSupport::TimeZone["Melbourne"].parse([date, time].join(' '))
    when "Sept-GAMSAT Sydney"
      ActiveSupport::TimeZone["Sydney"].parse([date, time].join(' '))
    when "Sept-GAMSAT Brisbane"
      ActiveSupport::TimeZone["Brisbane"].parse([date, time].join(' '))
    when "Sept-GAMSAT Adelaide"
      ActiveSupport::TimeZone["Adelaide"].parse([date, time].join(' '))
    when "Sept-GAMSAT Perth"
      ActiveSupport::TimeZone["Perth"].parse([date, time].join(' '))
    when "Other"
      ActiveSupport::TimeZone["Melbourne"].parse([date, time].join(' '))
    else
      ActiveSupport::TimeZone[self.city].parse([date, time].join(' '))
    end
  end

  def city_time_now
    case self.city
    when "Sept-GAMSAT Melbourne"
      ActiveSupport::TimeZone["Melbourne"].now
    when "Sept-GAMSAT Sydney"
      ActiveSupport::TimeZone["Sydney"].now
    when "Sept-GAMSAT Brisbane"
      ActiveSupport::TimeZone["Brisbane"].now
    when "Sept-GAMSAT Adelaide"
      ActiveSupport::TimeZone["Adelaide"].now
    when "Sept-GAMSAT Perth"
      ActiveSupport::TimeZone["Perth"].now
    when "Other"
      ActiveSupport::TimeZone["Melbourne"].now
    else
      ActiveSupport::TimeZone[self.city].now
    end
  end
end
