class Post < ApplicationRecord
  has_and_belongs_to_many :blog_categories, dependent: :nullify
  after_create :send_email_notifications! if ENV['EMAIL_CONFIRMABLE'] != "false"
  after_create :send_mail_to_active_course_enrolled_user, :send_mail_to_ticket_enquiry_user if ENV['EMAIL_CONFIRMABLE'] != "false"

  include FriendlyId
  friendly_id :name, use: :slugged

  has_attached_file :image, styles: { medium: "900x600#", thumb: "300x200>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :description, presence: true
  validates :blog_type, presence: true

  scope :list_archives, -> (blog=nil) {
    list = if blog.nil? then all else where(blog_type: blog_types[blog]) end
    list.group("date_trunc('month',created_at)").count
  }
  scope :by_month_year, -> (month, year) { where("extract(month from posts.created_at) = ? AND extract(year from posts.created_at) = ?", month, year) }
  scope :search_by_name, -> (term) { where('LOWER(posts.name) LIKE LOWER(?)', "%#{term}%") }

  enum blog_type: BlogCategory.blog_types.keys.map(&:to_sym)

  def mailing_list
    MailingList.find_or_create_by(name: "blog_#{self.blog_type}")
  end

  def send_email_notifications!
    self.mailing_list.mailing_list_subscriptions.reverse.each do |sub|
      next if (sub.email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i).nil?
      user = User.find_by(email: sub.email)
      unsub_email = UnsubscribeEmail.find_by(user_id: user.try(:id))
      if !unsub_email.present?
        BlogPostMailer.blog_mail_to_student(self, sub).deliver_later
      end
    end
  end

  def send_mail_to_active_course_enrolled_user
    User.student.includes(enrolments: :course).where("courses.expiry_date > ? ", Time.zone.today.beginning_of_day).references(:courses).each do |user|
      unsub_email = UnsubscribeEmail.find_by(user_id: user.try(:id))
      if !unsub_email.present?
        BlogPostMailer.blog_mail_to_student(self, user).deliver_later
      end
    end
  end

  def send_mail_to_ticket_enquiry_user
    EnquiryUser.where("created_at > ?", (Time.zone.today.beginning_of_day - 365.days)).select('distinct on (email) *').each do |user|
      unsub_email = UnsubscribeEmail.find_by(user_id: user.try(:id))
      if !unsub_email.present?
        BlogPostMailer.blog_mail_to_student(self, user).deliver_later
      end
    end
  end

  def map_blog_type
    if blog_type=="gamsat"
      new_blog_type="gamsat-preparation-courses"
    elsif blog_type=="umat"
      new_blog_type="umat-preparation-courses"
    else
      new_blog_type=blog_type
    end
    return new_blog_type
  end

  def product_line_type
    case blog_type
    when 'gamsat'
      'gamsat-preparation-courses'
    when 'umat'
      'umat-preparation-courses'
    when 'vce'
      'vce-preparation-courses'
    when 'hsc'
      'hsc-preparation-courses'
    end
  end

end
