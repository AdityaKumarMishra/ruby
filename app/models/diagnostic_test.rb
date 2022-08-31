class DiagnosticTest < ApplicationRecord
  validates :title, presence: true
  has_many :sections, as: :sectionable, dependent: :destroy
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :assessment_attempts, as: :assessable, dependent: :destroy

  filterrific(
      available_filters: [
          :by_product_line
      ]
  )

  scope :by_product_line, -> (type) {

    if type == "Gamsat"
      joins(:tags).where(tags: { id: Tag.find(246).self_and_descendants_ids })
    elsif type == "Umat"
      joins(:tags).where(tags: { id: Tag.find(30).self_and_descendants_ids })
    elsif type == "Vce"
      joins(:tags).where(tags: { id: Tag.find(325).self_and_descendants_ids + Tag.find(37).self_and_descendants_ids })
    elsif type == "Hsc"
      joins(:tags).where(tags: { id: Tag.find(326).self_and_descendants_ids + Tag.find(38).self_and_descendants_ids })
    end

  }

  def to_s
    title
  end
end
