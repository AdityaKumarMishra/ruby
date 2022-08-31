module Positionable
  extend ActiveSupport::Concern
  included do
    validates :position, presence: true
    belongs_to :product_line

    before_save :validate_position
  end

  class PositionNotUniqueError < StandardError
  end

  def validate_position
    product_line_positions = self.class.where(product_line_id: product_line_id).where.not(id: self&.id).pluck(:position).uniq.compact

    if product_line_positions.include?(position)
      self.errors.add(:position, 'is not unique within product line')

      return false
    end

    true
  end

  class_methods do
    def ordered_positions(product_line_id)
      where(product_line_id: product_line_id).where.not(position: nil).order(:position).pluck(:position)
    end
  end
end
