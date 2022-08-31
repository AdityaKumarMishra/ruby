class Questionnaire < ApplicationRecord
  belongs_to :user
  belongs_to :university, optional: true
  belongs_to :degree, optional: true

  validates :student_level, :source, :last_source, :student_region, presence: true
  validates :university_id, :degree_id, :year,
            presence: true, if: -> () { self.student_level && self.student_level == 'university'}

  validates_inclusion_of :umat_high_school, in: [true, false], if: -> () { self.student_level && self.student_level == 'university'}
  validates_inclusion_of :umat_uni, in: [true, false], if: -> () { self.student_level && self.student_level == 'university'}

  validates :current_highschool, :target_uni_course, :highschool_year_level,
            presence: true, if: -> () { self.student_level && self.student_level == 'highschool'}
  validates :designation, :learning_institution, :year_of_most_recent_completed_qualification, presence: true, if: -> () { self.student_level && self.student_level == 'other'}


  enum student_level: [ :university, :highschool, :other ]
  enum highschool_year_level: [ :year_10, :year_11, :year_12 ]
  enum student_region: [ :domestic, :international ]
end
