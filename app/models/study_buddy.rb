class StudyBuddy < ApplicationRecord

  belongs_to :university, optional: true
  belongs_to :degree, optional: true

  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, message: 'Please enter a valid email address' }
  validates_length_of :phone_number, minimum: 10, maximum: 15, allow_blank: true

  enum city: [:melbourne, :sydney, :brisbane, :adelaide, :perth, :other]
  enum city_area: [:city_centre, :north, :south, :east, :west, :other_area]
  enum focus_area: [:section_1, :section_2, :section_3, :other_section]
  enum buddy_type: [:online, :in_person, :either]
  enum exam_to_prepare: [:gamsat, :ucat]

  filterrific(
    available_filters: [
      :with_start,
      :with_end,
    ]
  )

  scope :with_start, -> (start_date){
    where('date(created_at) >= ?', start_date)
  }

  scope :with_end, -> (end_date){
    where('date(created_at) <= ?', end_date)
  }

end