# == Schema Information
#
# Table name: addresses
#
#  id              :integer          not null, primary key
#  number          :integer
#  street_name     :string
#  street_type     :string
#  subburb         :string
#  city            :string
#  post_code       :string
#  state           :string
#  country         :string
#  addresable_id   :integer
#  addresable_type :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryGirl.define do
  factory :address do
    number 1
    street_name 'Main street'
    street_type 'Main'
    suburb 'North Sydney'
    city 'Sydney'
    post_code '2055'
    state 2
    country 1
    line_one 'Line one'
    line_two 'Line two'
  end
end
