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

require 'rails_helper'

RSpec.describe CourseAddress, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
