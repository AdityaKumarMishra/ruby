# == Schema Information
#
# Table name: course_addresses
#
#  id               :integer          not null, primary key
#  number           :integer
#  street_name      :string
#  street_type      :string
#  subburb          :string
#  post_code        :string
#  state            :string
#  country          :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  city             :string
#  institution_name :string
#

class CourseAddress < ApplicationRecord
  has_many :course_versions

  def name_with_initial
    "#{first_name.first}. #{last_name}"
  end
end
