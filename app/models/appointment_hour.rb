class AppointmentHour < ApplicationRecord
	belongs_to :appointment
	filterrific(
	    default_filter_params: { },
	    available_filters: [
	        :with_start,
	        :with_end,
          :tutor,
          :with_pay_period,
          :student,
          :city
	    ]
  	)
  	scope :with_start, lambda { |with_start| where('DATE(appointment_hours.finish_date) >= ? AND appointment_hours.hours != 0', with_start.to_date) }
  	scope :with_end, lambda { |with_end| where('DATE(appointment_hours.finish_date) <= ? AND appointment_hours.hours != 0', with_end.to_date) }
  	scope :with_hours, lambda {  where('DATE(appointment_hours.finish_date) <= ? AND appointment_hours.hours != 0', Time.zone.now.to_date) }
    scope :with_start_zero, lambda { |with_start| where('DATE(appointment_hours.finish_date) >= ?', with_start.to_date) }
    scope :with_end_zero, lambda { |with_end| where('DATE(appointment_hours.finish_date) <= ?', with_end.to_date) }
    scope :with_end_zero_not_equal, lambda { |with_end| where('DATE(appointment_hours.finish_date) < ?', with_end.to_date) }
    scope :with_hours_zero, lambda { joins(:appointment).where('DATE(COALESCE(appointment_hours.finish_date,appointments.created_at)) <= ?', Time.zone.now.to_date) }
    scope :with_tutor, lambda { |tutor| joins(appointment: :tutor).where("users.first_name ilike ? OR users.last_name ilike ? OR TRIM(CONCAT(COALESCE(users.first_name, ''), ' ', COALESCE(users.last_name, ''))) ilike ?", "%#{tutor}%", "%#{tutor}%", "%#{tutor}%") }
    scope :created_with_start, lambda { |with_start| joins(:appointment).where('DATE(COALESCE(appointment_hours.finish_date,appointments.created_at)) >= ?', with_start.to_date) }
    scope :created_with_end, lambda { |with_end| joins(:appointment).where('DATE(COALESCE(appointment_hours.finish_date,appointments.created_at)) <= ?', with_end.to_date) }

  	def self.get_filtered_hours(with_start, with_end)
  		if with_start.present? && with_end.present?
  			with_start_zero(with_start).with_end_zero(with_end)
  		elsif with_start.present?
  			with_start_zero(with_start)
  		elsif with_end.present?
  			with_end_zero(with_end)
  		else
  			with_hours_zero
  		end
  	end

    def self.get_filtered_hours_created_at(filter_params)
      if filter_params[:with_start].present? && filter_params[:with_end].present?
        hours = AppointmentHour.created_with_start(filter_params[:with_start]).created_with_end(filter_params[:with_end])
      elsif filter_params[:with_start].present?
        hours = created_with_start(filter_params[:with_start])
      elsif filter_params[:with_end].present?
        hours = created_with_end(filter_params[:with_end])
      else
        hours = with_hours_zero
      end

      if filter_params[:tutor].present?
        hours = hours.with_tutor(filter_params[:tutor])
      end

      hours
    end

    def self.get_filtered_hours_zero(filter_params)
      if filter_params.present?
        if filter_params[:with_start].present? && filter_params[:with_end].present?
          hours = AppointmentHour.with_start_zero(filter_params[:with_start]).with_end_zero(filter_params[:with_end])
        elsif filter_params[:with_start].present?
          hours = with_start_zero(filter_params[:with_start])
        elsif filter_params[:with_end].present?
          if filter_params[:not_equal]
            hours = with_end_zero_not_equal(filter_params[:with_end])
          else
            hours = with_end_zero(filter_params[:with_end])
          end
        else
          hours = with_hours_zero
        end
        if filter_params[:tutor].present?
          hours = hours.with_tutor(filter_params[:tutor])
        end
      else
          hours = with_hours_zero
      end
      hours
    end

end
