class QuoteTheme < ApplicationRecord
	has_many :quote_banks , dependent: :destroy
	validates :theme , presence: true
end
