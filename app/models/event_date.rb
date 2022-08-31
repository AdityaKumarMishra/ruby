class EventDate < ApplicationRecord
	validates :title, :product_line, :event_start_date, :event_start_time, :description, presence: true
end
