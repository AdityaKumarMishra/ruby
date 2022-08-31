class ProductLine < ApplicationRecord
  has_many :product_versions
  has_many :master_features
  has_many :documents
  has_many :announcements

  validates :name, presence: true
end
