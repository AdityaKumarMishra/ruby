class ManualEmailAnnouncement < ApplicationRecord
  require "open-uri"
  enum greetings: ["Dear [Student First Name]", "Welcome [Student First Name]"]
  has_and_belongs_to_many :product_versions
  has_and_belongs_to_many :courses
  has_and_belongs_to_many :master_features
  has_attached_file :first_docuemnt
  has_attached_file :second_docuemnt
  has_attached_file :third_docuemnt
  validates_attachment_content_type :first_docuemnt, content_type: 'application/pdf'
  validates_attachment_content_type :second_docuemnt, content_type: 'application/pdf'
  validates_attachment_content_type :third_docuemnt, content_type: 'application/pdf'

  before_destroy :clear_associations

  def clear_associations
    self.product_versions.clear
    self.courses.clear
    self.master_features.clear
  end

  def deep_clone
    new_email_template = self.dup
    new_email_template.course_ids = self.course_ids
    new_email_template.product_version_ids = self.product_version_ids
    new_email_template.master_feature_ids = self.master_feature_ids
    if self.first_docuemnt.file?
      new_email_template.first_docuemnt = open(self.first_docuemnt.url) 
      new_email_template.first_docuemnt_file_name = self.first_docuemnt_file_name
    end
    if self.second_docuemnt.file?
      new_email_template.second_docuemnt = open(self.second_docuemnt.url)
      new_email_template.second_docuemnt_file_name = self.second_docuemnt_file_name
    end
    if self.third_docuemnt.file?
      new_email_template.third_docuemnt = open(self.third_docuemnt.url) 
      new_email_template.third_docuemnt_file_name = self.third_docuemnt_file_name
    end
    return new_email_template
  end

  def sending_emails
    if self.courses.present? && self.product_versions.present? && self.master_features.present?
      course_ids = self.courses.pluck(:id)
      product_version_ids = self.product_versions.pluck(:id)
      master_feature_ids = self.master_features.pluck(:id)
      users = User.joins(enrolments: [:course, purchase_item: [:order], :feature_logs => [:product_version_feature_price]]).where("DATE(courses.expiry_date) >= ? AND feature_logs.acquired IS NOT NULL AND product_version_feature_prices.master_feature_id in (?) AND courses.product_version_id in (?) AND courses.id in (?) AND enrolments.state in (?) AND orders.status in (?)", Date.today, master_feature_ids,product_version_ids,course_ids, [0], [2,3,5])
    elsif self.courses.present? && self.product_versions.present?
      course_ids = self.courses.pluck(:id)
      product_version_ids = self.product_versions.pluck(:id)
      users = User.joins(enrolments: [:course, purchase_item: [:order], :feature_logs => [:product_version_feature_price]]).where("DATE(courses.expiry_date) >= ? AND feature_logs.acquired IS NOT NULL AND courses.product_version_id in (?)  AND courses.id in (?) AND enrolments.state in (?) AND orders.status in (?)", Date.today, product_version_ids,course_ids ,[0], [2,3,5])
    elsif self.courses.present? && self.master_features.present?
      course_ids = self.courses.pluck(:id)
      master_feature_ids = self.master_features.pluck(:id)
      users = User.joins(enrolments: [:course, purchase_item: [:order], :feature_logs => [:product_version_feature_price]]).where("DATE(courses.expiry_date) >= ? AND feature_logs.acquired IS NOT NULL AND product_version_feature_prices.master_feature_id in (?) AND courses.id in (?) AND enrolments.state in (?) AND orders.status in (?)", Date.today, master_feature_ids,course_ids ,[0], [2,3,5])
    elsif self.product_versions.present? && self.master_features.present?
      product_version_ids = self.product_versions.pluck(:id)
      master_feature_ids = self.master_features.pluck(:id)
      users = User.joins(enrolments: [:course, purchase_item: [:order], :feature_logs => [:product_version_feature_price]]).where("DATE(courses.expiry_date) >= ? AND feature_logs.acquired IS NOT NULL AND product_version_feature_prices.master_feature_id in (?) AND courses.product_version_id in (?) AND enrolments.state in (?) AND orders.status in (?)", Date.today, master_feature_ids,product_version_ids ,[0], [2,3,5])
    elsif self.courses.present?
      course_ids = self.courses.pluck(:id)
      users = User.joins(enrolments: [:course, purchase_item: [:order]]).where("DATE(courses.expiry_date) >= ? AND courses.id in (?) AND enrolments.state in (?) AND orders.status in (?)", Date.today, course_ids, [0], [2,3,5])
    elsif self.product_versions.present?
      product_version_ids = self.product_versions.pluck(:id)
      users = User.joins(enrolments: [:course, purchase_item: [:order]]).where("DATE(courses.expiry_date) >= ? AND courses.product_version_id in (?) AND enrolments.state in (?) AND orders.status in (?)", Date.today, product_version_ids, [0], [2,3,5])
    elsif self.master_features.present?
      master_feature_ids = self.master_features.pluck(:id)
      users = User.joins(enrolments: [:course, purchase_item: [:order], :feature_logs => [:product_version_feature_price]]).where("DATE(courses.expiry_date) >= ? AND feature_logs.acquired IS NOT NULL AND product_version_feature_prices.master_feature_id in (?) AND enrolments.state in (?) AND orders.status in (?)", Date.today, master_feature_ids,[0], [2,3,4])
    end
    if users.present?
      users = users.uniq
      users.uniq.each do |user|
        ManualEmailAnnouncementMailer.announcement_email(user, self).deliver_later
      end if users.present?
    end
  end
end
