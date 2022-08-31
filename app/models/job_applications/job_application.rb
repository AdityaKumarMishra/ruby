# == Schema Information
#
# Table name: job_applications
#
#  id                  :integer          not null, primary key
#  first_name          :string
#  last_name           :string
#  phone_number        :string
#  email               :string
#  job_application_form_id  :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class JobApplication < ApplicationRecord
  belongs_to :job_application_form
  has_many :application_answers, dependent: :destroy
  has_one :address, as: :addresable, dependent: :destroy
  has_one :cover_letter, dependent: :destroy
  has_one :resume, dependent: :destroy
  has_many :application_attachments, dependent: :destroy


  after_create :mail_based_on_certai_period

  after_update :mail
  enum degree_type: {
    "PhD": 'PhD',
    "Law": 'Law',
    "Medicine": 'Medicine',
    "Masters": 'Masters',
    "Certificate": 'Certificate',
    "General Undergraduate": 'general_undergraduate'
  }

  enum status: {
    "0.0 Not Reviewed": 'not_reviewed',
    "1.1 Under Review": 'under_review',
    "1.2 Sent Initial Assessment": 'initial_assesment',
    "1.3 Awaiting Interview": "awaiting_interview",
    "1.4 Interview Review Pending": "interview_review_pending",
    "2.1 Excellent Candidate": 'excellent_candidate',
    "2.2 Good Candidate": 'good_candidate',
    "2.3 Reassess if Needed": 'reassess_if_needed',
    "3.1 Successful Interview": 'successful_interview',
    "3.2 Unsuccessful Interview": 'unsuccessful_interview',
    "3.3 Rejected": 'rejected',
    "3.4 Archived": 'archived'
  }


  accepts_nested_attributes_for :application_answers, :address, :cover_letter, :resume
  accepts_nested_attributes_for :application_attachments, reject_if: :all_blank, allow_destroy: true

  validates_associated :cover_letter, :resume, :application_attachments
  validates :name,
            :phone_number,
            :email,
            :atar, :wam,
            :applicant_type,
            presence: { message: 'Please complete field' }

  validates :phone_number, numericality: true
  validates_length_of :phone_number, minimum: 10, maximum: 15

  validates :degree_type, :degree, :graduation, :hours_available, presence: { message: 'Please complete field' }, if: Proc.new { |job_application| job_application.applicant_type == 'Current University Student' }

  validates_inclusion_of :domestic, in: [true, false], if: Proc.new { |job_application| job_application.applicant_type == 'Current University Student' }

  filterrific(
    available_filters: [
      :sorted_by,
      :with_status,
      :with_name,
      :with_degree_type,
      :with_hours_available,
      :with_state,
      :with_atar,
      :with_wam,
      :with_degree,
      :with_graduation,
      :with_domestic,
      :with_position,
      :with_content_tag

    ]
  )
  scope :sorted_by, -> (key){ order(Arel.sql(key)) }
  scope :with_status, -> (status){ where(status: [status, JobApplication.statuses[status]])}
  # scope :with_name, -> (name){ where('lower(name) LIKE :name', name: "%#{name.downcase}%") }
  # scope :with_name, -> (name){ where "name ILIKE :name OR email ILIKE :name OR name ||' '|| email ILIKE :name OR email ||' '|| name ILIKE :name", name: "%#{name}%" }

  scope :with_name, -> (name){ where "name ILIKE :name OR email ILIKE :name OR name ||' '|| email ILIKE :name OR email ||' '|| name ILIKE :name OR status ILIKE :name OR email ILIKE :name OR status ||' '|| email ILIKE :name OR email ||' '|| status ILIKE :name", name: "%#{name}%" }

  scope :with_degree_type, -> (dt){ where(degree_type: [dt, JobApplication.degree_types[dt]]) }
  scope :with_hours_available, -> (hours){ where('hours_available >= ?', hours.to_s)} # not working as hours_available is a string not integer
  scope :with_state, -> (state){ includes(:address).where(addresses: {state: state}) } # GRAD-2425 Job Application - Minor Updates
  scope :with_atar, -> (atar){ where(atar: atar)}
  scope :with_wam, -> (wam){ where(wam: wam)}
  scope :with_degree, -> (degree){ where(degree: degree)}
  scope :with_graduation, -> (graduation){ where(graduation: graduation)}
  scope :with_domestic, -> (domestic){ where(domestic: domestic)}
  scope :with_position, -> (position){ includes(:application_answers).where("application_answers.content=?", position).references(:application_answers) }
  scope :with_content_tag, -> (tag){ includes(:application_answers).where("application_answers.content_tag=?", tag).references(:application_answers) }

  def self.options_for_sort_by
    [
      ['Status', 'status ASC'],
      ['Submission date (newest first)', 'job_applications.created_at DESC'],
      ['Submission date (oldest first)', 'job_applications.created_at ASC'],
      ['Hours Available', 'hours_available DESC NULLS LAST'],
      ['Expected Graduation Date', 'graduation DESC NULLS LAST'],
      ['Domestic International', 'domestic ASC'],
      ['Name', 'name DESC'],
      ['WAM', 'wam DESC'],
      ['ATAR', 'atar DESC'],
      ['Degree', 'degree DESC'],
      ['Interview date (newest first)', 'job_applications.interview_date DESC NULLS LAST'],
      ['Interview date (oldest first)', 'job_applications.interview_date ASC NULLS LAST']
    ]
  end

  def self.order_by_name
    order("name ASC NULLS FIRST")
  end

  def self.order_by_graduation
    order("graduation ASC NULLS FIRST")
  end

  def self.order_by_degree
    order("degree ASC NULLS FIRST")
  end

  def self.order_by_domestic
    order("domestic ASC NULLS FIRST")
  end

  def self.order_by_atar
    order("atar ASC NULLS FIRST")
  end

   def self.order_by_wam
    order(" wam ASC NULLS FIRST")
  end

  def self.options_for_status
    statuses.keys
  end

  def self.options_for_student_type
    [
      ['Domestic Student', true],
    ['International Student', false]
    ]
  end

  def self.options_for_degree_type
    degree_types.keys
  end

  def self.options_for_position
    [
      ['GAMSAT Tutor', 'GAMSAT Tutor'],
      ['HSC English Advanced Tutor', 'HSC English Advanced Tutor'],
      ['HSC Maths Extension Tutor', 'HSC Maths Extension Tutor'],
      ['UMAT Tutor', 'UMAT Tutor'],
      ['VCE English Tutor', 'VCE English Tutor'],
      ['VCE Maths Methods Tutor', 'VCE Maths Methods Tutor']
    ]
  end

  def self.options_for_state
    Address.states.collect{|k, v| [k, v]}
  end

  def self.build(job_application_form)
    job_application = self.new

    build_application_answers(job_application_form, job_application)
    build_attachments(job_application)
    job_application.build_address

    job_application
  end

  def self.build_application_answers(job_application_form, job_application)
    job_application_form.application_questions.each do |q|
      job_application.application_answers.build(application_question_id: q.id)
    end
  end

  def self.build_attachments(job_application)
    job_application.build_cover_letter
    job_application.build_resume
  end

  def validate_attachments
    self.build_cover_letter if self.cover_letter.nil?
    self.build_resume if self.resume.nil?
  end

  def rankable_answers
    self.application_answers.joins(:application_question).where(application_questions: { rankable: true } )
  end

  def self.zip_applications(applications)
    file_name = "Applications - #{Date.today.to_s}.zip"
    temp_file = Tempfile.new(file_name)

    files = []
    applications.each_with_index do |application, i|
      folder = "#{i} #{application.name}"
      files += application_files(application, folder)
    end

    Zip::File.open(temp_file.path, Zip::File::CREATE) do |zipfile|
      files.each do |f|
        zipfile.add(f[:zip_path], f[:file_path])
      end
    end

    { name: file_name, data: File.read(temp_file.path) }

    # All the temporary files and the files paperclip downloads will be GC'd automatically
  end

  def self.application_files(application, folder)
    file_list = []

    file_list.push get_file_ref("#{folder}/Resume-#{application.resume.document_file_name}", application.resume.document)
    file_list.push get_file_ref("#{folder}/Cover Letter-#{application.cover_letter.document_file_name}", application.cover_letter.document)

    if !application.notes.nil?
      notes_file = Tempfile.new('notes')
      notes_file.write application.notes

      file_list.push({
        zip_path: "#{folder}/Notes.txt",
        file_path: notes_file.path,

        # Ensure we always keep a reference to notes_file
        # Otherwise, if we lose the reference and it is GC'd, TempFile will delete the
        # file before it is used.
        tempfile_ref: notes_file
      })
    end

    application.application_attachments.each_with_index do |attachment, i|
      file_list.push get_file_ref("#{folder}/attachments/#{i} #{attachment.document_file_name}", attachment.document)
    end

    file_list
  end

  def self.get_file_ref(zip_path, document)
    file = Paperclip.io_adapters.for(document)
    {
      zip_path: zip_path,
      file_path: file.path,

      # Ensure we always keep a reference to file
      # Otherwise, the file paperclip retrieved for us will be automatically
      # deleted whenever the file variable gets garbage collected by Ruby
      paperclip_ref: file,
    }
  end

  private

  def mail_based_on_certai_period
    if self.job_application_form_id == 18
      app_type = self.application_answers.where(application_question_id: 114).first
      tutor_type = app_type.content if app_type
      created_month = self.created_at.month
      gam_time  = (4..6).include?(created_month)
      um_time = (8..12).include?(created_month) || created_month == 1
      if tutor_type
        if (tutor_type  == "GAMSAT Tutor" && gam_time) || (tutor_type  == "UMAT Tutor" && um_time) || tutor_type.include?("VCE") || tutor_type.include?("HSC")
          JobApplicationMailer.certain_period_application(self).deliver_later
        end
      end
    end
  end

  def mail
    if (self.status_changed? && self.status == "3.1 Successful Interview") && ENV['EMAIL_CONFIRMABLE'] != "false"
      JobApplicationMailer.successful_job_application(self).deliver_later
    end

    if (self.status_changed? && self.status == "3.2 Unsuccessful Interview") && ENV['EMAIL_CONFIRMABLE'] != "false"
      JobApplicationMailer.unsuccessful_job_application(self).deliver_later
    end
  end

end

