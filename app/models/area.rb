# == Schema Information
#
# Table name: areas
#
#  id               :integer          not null, primary key
#  city             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  institution_name :string
#

class Area < ApplicationRecord
  validates :city, presence: true, uniqueness: { case_sensitive: false }

  def to_s
    city
  end
end
