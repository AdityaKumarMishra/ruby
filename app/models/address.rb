# == Schema Information
#
# Table name: addresses
#
#  id              :integer          not null, primary key
#  number          :integer
#  street_name     :string
#  street_type     :string
#  suburb         :string
#  city            :string
#  post_code       :string
#  state           :string
#  country         :string
#  addresable_id   :integer
#  addresable_type :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Address < ApplicationRecord
  belongs_to :addresable, polymorphic: true

  validates :line_one, :suburb, :post_code, :state, :country, presence: { message: 'Please complete field' }
  validates :post_code, presence: true
  validates_length_of :post_code, maximum: 10

  enum state: [:other, :victoria, :new_south_wales, :queensland, :australian_capital_territory, :south_australia, :northern_territory, :western_australia, :tasmania]
  enum country: [:australia, :asia_pacific, :europe, :united_states, :new_zealand, :africa]
  def one_line_address
    if line_two.present?
      "#{line_one}, #{line_two}, #{suburb}, #{state.try(:humanize).try(:titleize)}, #{post_code}, #{country.try(:humanize).try(:titleize)}"
    else
      "#{line_one}, #{suburb}, #{state.try(:humanize).try(:titleize)}, #{post_code}, #{country.try(:humanize).try(:titleize)}"
    end
  end
end
