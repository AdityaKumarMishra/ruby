class University < ApplicationRecord
  has_many :questionnaires

  def to_s
    name
  end
end
