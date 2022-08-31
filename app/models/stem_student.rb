# == Schema Information
#
# Table name: stem_students
#
#  id          :integer          not null, primary key
#  time_left   :integer
#  description :text
#  title       :string
#  mcqs        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#  mcq_stem_id :integer
#  tag_id      :integer
#  subject_id  :integer
#

class StemStudent < ApplicationRecord
  belongs_to :user
  belongs_to :mcq_stem
  belongs_to :tag, optional: true
  belongs_to :subject, optional: true
  serialize :mcqs, Array

  filterrific(
      default_filter_params: { sorted_by: 'created_at_desc' },
      available_filters: [
          :sorted_by,
          :search_query,
          :with_tag_id,
          :with_subject
      ]
  )

  scope :stems_for_student, -> (current_student_id) { where(user_id: current_student_id) }
  scope :with_tag_id, lambda { |with_tag_id| where(:tag_id => with_tag_id)  }
  scope :with_tag_name, lambda { |with_tag_name| joins(:tags).where('tags.name = ?', with_tag_name) }
  scope :with_subject, lambda { |with_subject| joins(:subject).where('subjects.title = ?', with_subject)  }
  # scope :with_difficulty, lambda { |level|
  #   return nil  if level.blank?
  #   where('(SELECT SUM(mcqs.difficulty) FROM mcqs where mcqs.mcq_stem_id = mcq_stems.id AND mcqs.publish IS TRUE) BETWEEN ? AND ?',McqStem::DIFFICULTY_LEVELS[level.to_sym][:bottom], McqStem::DIFFICULTY_LEVELS[level.to_sym][:top])
  # }

  scope :sorted_by, lambda { |sort_option|
    # extract the sort direction from the param value.
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
      when /^created_at_/
        order("stem_students.created_at #{ direction }")
      when /^tag_name_/
        order("LOWER(tags.name) #{ direction }").includes(:tag)
      else
        raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }

  scope :search_query, lambda { |query|
    # Searches the students table on the 'first_name' and 'last_name' columns.
    # Matches using LIKE, automatically appends '%' to each term.
    # LIKE is case INsensitive with MySQL, however it is case
    # sensitive with PostGreSQL. To make it work in both worlds,
    # we downcase everything.
    return nil  if query.blank?
    term = query.to_s.downcase
    # replace "*" with "%" for wildcard searches,
    # append '%', remove duplicate '%'s
    term = (term.gsub('*', '%') + '%').gsub(/%+/, '%')
    where('(LOWER(stem_students.title) LIKE ?)', term)
  }
end
