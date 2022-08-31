# == Schema Information
#
# Table name: application_questions
#
#  id                  :integer          not null, primary key
#  answer_type         :integer
#  content             :text
#  job_application_form_id     :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#


class ApplicationQuestion < ApplicationRecord
  belongs_to :job_application_form
  has_many :answer_options, dependent: :destroy
  has_one :application_answer

  validates :content, presence: true
  validate :dropdown_has_answers
  accepts_nested_attributes_for :answer_options, reject_if: :all_blank, allow_destroy: true

  enum answer_type: [:text, :dropdown, :dropdown_multiple]

  default_scope { order(id: :asc) }

  def dropdown_has_answers
    errors.add(:content, 'Please provide at least one answer') if answer_type != 'text' && answer_options.first.nil?
  end

  def self.dropdown_question?(answer_type)
    answer_type.eql?('dropdown') || answer_type.eql?('dropdown_multiple')
  end

  def self.text_question?(answer_type)
    answer_type.eql?('text')
  end

end
