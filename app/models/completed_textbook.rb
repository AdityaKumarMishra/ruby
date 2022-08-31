class CompletedTextbook < ApplicationRecord
  belongs_to :user
  belongs_to :textbook
end
