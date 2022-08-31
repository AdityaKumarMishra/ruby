class TextbookPrint < ApplicationRecord
  belongs_to :textbook
  belongs_to :user
end
