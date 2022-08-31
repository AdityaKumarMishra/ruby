class Tag < ApplicationRecord
  extend ActsAsTree::TreeView
  extend ActsAsTree::TreeWalker
  acts_as_tree order: 'name'
  validate :parent_cannot_be_itself
  validates :name, uniqueness: true, presence: true
  has_many :taggings, dependent: :destroy
  has_many :mcq_stems, through: :taggings, source: :taggable, source_type: 'McqStem'
  has_many :essays, through: :taggings, source: :taggable, source_type: 'Essay'
  has_many :mcqs, through: :taggings, source: :taggable, source_type: 'Mcq'
  has_many :vods, through: :taggings, source: :taggable, source_type: 'Vod'
  has_many :tickets, -> { eager_load :ticket_answers }, through: :taggings, source: :taggable, source_type: 'Ticket'
  #has_many :tutor_profiles, through: :taggings, source: :taggable, source_type: 'TutorProfile'
  has_many :tutor_profiles, through: :taggings, source: :taggable, source_type: 'TutorProfile'
  has_many :tutors, through: :tutor_profiles
  has_many :staff_profiles, through: :taggings, source: :taggable, source_type: 'StaffProfile'
  has_many :staffs, through: :staff_profiles
  # has_and_belongs_to_many :tutor_profiles
  has_many :overseeings, dependent: :destroy
  has_many :overseeing_users, through: :overseeings, source: 'user'
  has_many :performance_stats, dependent: :destroy

  scope :children, -> { where.not(parent_id: nil) }
  scope :level_one, -> { where(parent_id: nil).order(:name) }

  scope :level_one_exclude_pt_public, -> { level_one.where.not(id: 253).order(:name) }
  scope :public_tags, -> { where(is_public: true)}

  scope :with_level, -> (tag_id) {
    find(tag_id)
   }

  filterrific(
      available_filters: [
          :by_product_line
      ]
  )

  scope :by_product_line, -> (product_line) {
    level_one.where('name like ?', "%#{product_line.upcase}%").map(&:self_and_descendants).flatten if product_line.present? }

  def get_tutors
    self.staff_profiles.map {|sp| sp.staff}
  end

  def self.root_tags
    where(parent: nil)
  end

  def child_tickets
    self_and_descendants.map(&:tickets).flatten
  end

  def answered_child_tickets
    # Ticket with an answer, note this may or may not be resolved. Generally you want resolved_child_tickets
    child_tickets.select { |ticket| ticket.ticket_answers.any? }
  end

  def resolved_child_tickets
    # tickets that are resolved
    child_tickets.select(&:resolved?)
  end

  def unanswered_child_tickets
    # Ticket without an answer, note this may or may not be resolved. Generally you want unresolved_child_tickets
    child_tickets.select {|ticket| !ticket.ticket_answers.any?}
  end

  def unresolved_child_tickets
    child_tickets.reject(&:resolved?)
  end

  def self.options_for_select
    order('LOWER(name)').map { |e| [e.name, e.id] }
  end

  def self_and_descendants_ids
    Rails.cache.fetch("tag-#{cache_key}/tags", expires_in: 5.hour) do
      self_and_descendants.map(&:id)
    end
  end

  def self_and_ancestors_ids
    self_and_ancestors.map(&:id)
  end

  def tag_online_exams(state)
    if state == "Yes"
      self.taggings.where(taggable_type: "OnlineExam").collect(&:taggable).select{|e| e.published == true}.map{|e| [e.title, e.id]}
    elsif state == "No"
      self.taggings.where(taggable_type: "OnlineExam").collect(&:taggable).select{|e| e.published == false}.map{|e| [e.title, e.id]}
    else
      self.taggings.where(taggable_type: "OnlineExam").collect(&:taggable).map{|e| [e.title, e.id]}
    end
  end

  def mcqs_count_filter(published, location, exam)
    if published == "Yes" && location == "MCQ Bank"
      self.mcq_stems.published.non_examinable.map(&:id)
    elsif published == "No" && location == "MCQ Bank"
      self.mcq_stems.non_published.non_examinable.map(&:id)
    elsif published == "All" && location == "MCQ Bank"
      self.mcq_stems.non_examinable.map(&:id)
    elsif published == "Yes" && location == "All"
      self.mcq_stems.published.map(&:id)
    elsif published == "No" && location == "All"
      self.mcq_stems.non_published.map(&:id)
    elsif published == "Yes" && location == "Online Exams" && exam != "All"
      exam_id = OnlineExam.find(exam).id
      self.mcq_stems.published.examinable.includes(section_items: :section).where('sections.sectionable_type = ? AND sections.sectionable_id = ?', 'OnlineExam', exam_id).references(:sections).map(&:id)
    elsif published == "No" && location == "Online Exams" && exam != "All"
      exam_id = OnlineExam.find(exam).id
      self.mcq_stems.non_published.examinable.includes(section_items: :section).where('sections.sectionable_type = ? AND sections.sectionable_id = ?', 'OnlineExam', exam_id).references(:sections).map(&:id)
    elsif published == "All" && location == "Online Exams" && exam != "All"
      exam_id = OnlineExam.find(exam).id
      self.mcq_stems.examinable.includes(section_items: :section).where('sections.sectionable_type = ? AND sections.sectionable_id = ?', 'OnlineExam', exam_id).references(:sections).map(&:id)
    elsif published == "All" && location == "Online Exams" && exam == "All"
      self.mcq_stems.examinable.map(&:id)
    elsif published == "Yes" && location == "Online Exams" && exam == "All"
      self.mcq_stems.published.examinable.map(&:id)
    elsif published == "No" && location == "Online Exams" && exam == "All"
      self.mcq_stems.non_published.examinable.map(&:id)
    else
      self.mcq_stems.map(&:id)
    end
  end

  def published_and_non_published_mcq_stem(selected)
    if selected == "Yes"
      self.mcq_stems.published.map(&:id)
    elsif selected == "No"
      self.mcq_stems.non_published.map(&:id)
    else
      self.mcq_stems.map(&:id)
    end
  end

  def self.get_staff_for(product_line)
    product_tagging_hashes = {
      gamsat: 'GM GAMSAT',
      umat: 'UM UMAT',
      vce_math: 'MA Mathematics VCE',
      hsc_math: 'MA Mathematics HSC',
      vce_english: 'VE VCE English',
      hsc_english: 'HE HSC English Advanced',
    }
    name = product_tagging_hashes[product_line.to_sym]
    tag = Tag.find_by_name(name) # Find the tag with the given name
    return {} if tag.nil?
    tag.self_and_descendants # Also find all the child tags
        .select {|tag| !tag.staffs.empty?} # Remove tags with no staff
        .map {|tag| [tag.name, tag.staffs]} # Map to a hash of {tag.name => tag.staffs}
        .to_h
  end

  def answerers
    staff_tag = self
    while staff_tag.staffs.includes(:tutor_profile).where("tutor_profiles.issue_ticket=?", true).references(:tutor_profiles).empty? && !staff_tag.parent.nil?
      staff_tag = staff_tag.parent
    end
    if staff_tag.staffs.empty?
      answerers = []
      answerers << User.find_by_email("student.care@gradready.com.au")
      # answerers << User.find_by_email("peitong.li@gradready.com.au")
    else
      staff_tag.staffs.includes(:tutor_profile).where("tutor_profiles.issue_ticket=?", true).references(:tutor_profiles).shuffle
    end

  end

  # Returns the tag one below the root of the current tag (or itself if no parent meaning is a root)
  def second_sub_root
    if parent.present? && parent.parent.present?
      return parent.second_sub_root
    end
    return self
  end

  # Select only the most specific tag IDs, ie remove redundant parent tags
  def self.most_specific_ids(tags_ids)
    #Convert into tag records
    tags = Tag.where(id: tags_ids)

    ids = []
    tags.each do |tag|
      anc_ids = tag.self_and_ancestors_ids - [tag.id]
      if anc_ids.present?
        (anc_ids - tags.ids).empty? ? '' : ids << tag.id
      else
        ids << tag.id
      end
    end
    ids #return ids
  end

  def self.child_tags(tags)
    tags.select { |t| t.parent_id }
  end

  # Retrieve overseeing emails from current tags and all parent tags
  def self.overseeing_receivers_for_tags(tags)
    all_tags = tags.map(&:self_and_ancestors).flatten
    all_tag_ids = all_tags.map(&:id).uniq
    all_user_ids = Overseeing.includes(:user).where(tag_id: all_tag_ids).map(&:user_id).uniq
    Overseeing.includes(:user).where(tag_id: all_tag_ids).map{ |overseeing| overseeing.user }.map(&:email).uniq
  end

  private

  def parent_cannot_be_itself
    return true if parent_id.nil?
    errors.add(:parent, 'cannot be itself') if id == parent_id
  end

  def self.search_descendant_tags(query)
    if query.empty?
      return Tag.none
    else
      tags = Tag.children
      tokens = query.split(/[ -]/)
      tokens.each do |t|
        tags = Tag.where('lower(name) like ?', "%#{t.downcase}%")
      end
      return tags
    end
  end

  def self.mcq_statistics(user, tags)
  #   Returns a hash of a hash that gives statistics about the mcqs and a particular tag
    statistics = {}
    mcqs_attempted = user.mcq_attempt_mcqs
    tags.each do |tag|
      tag_ids = tag.self_and_descendants_ids

      statistics[tag.id] = {}
      statistics[tag.id]['total_mcq_by_tag'] =
        Mcq
          .includes(:mcq_stem, :tagging)
          .where(mcq_stems: { published: true, examinable: false }, taggings: { tag_id: tag_ids }, examinable: false)
          .size
      statistics[tag.id]['viewed_mcq_by_tag'] =
        mcqs_attempted.includes(:mcq_stem, :tagging)
          .where(mcq_stems: { published: true }, taggings: { tag_id: tag_ids})
          .size
      statistics[tag.id]['correct_mcq_by_tag'] =
        user
          .mcq_attempts
          .joins(:mcq_stem, :mcq_answer, mcq: :tagging)
          .where(mcq_stems: { published: true }, taggings: { tag_id: tag_ids }, mcq_answers: { correct: true })
          .size
    end
    statistics
  end
end
