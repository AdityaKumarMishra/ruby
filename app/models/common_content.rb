class CommonContent < ApplicationRecord
  validates_length_of :contact_number, maximum: 45
  validates_length_of :contact_number2, maximum: 45
end
