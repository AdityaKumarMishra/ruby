class TextbookRead < ActiveRecord::Base
	belongs_to :user
	belongs_to :textbook
	validates :textbook_id, uniqueness: {scope: :user_id}
end
