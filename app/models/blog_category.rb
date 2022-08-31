class BlogCategory < ApplicationRecord
  include FriendlyId
  friendly_id :name#, use: :slugged
  # friendly_id :slug_candidates, use: :slugged

  enum blog_type: [:gamsat, :umat, :vce, :hsc]
  has_and_belongs_to_many :posts, dependent: :nullify

  scope :by_product_line, -> (product_line){ where(blog_type: product_line)}
  filterrific(
      available_filters: [
          :by_product_line
      ]
  )


 #  def slug_candidates
 #    [
 #      [:blog_type, :name]
 #    ]
 #  end

 #  def should_generate_new_friendly_id?
	#   name_changed?
	# end

end
