class FeatureLog < ApplicationRecord
  belongs_to :product_version_feature_price
  has_one :master_feature, through: :product_version_feature_price
  belongs_to :enrolment
  has_one :course, through: :enrolment
  has_one :user, through: :enrolment
  has_one :purchase_item, as: :purchasable, dependent: :destroy
  has_one :master_feature, through: :product_version_feature_price

  def assign_essays(email_if_none = true, product_version_id = nil, amount = qty)
    return if amount == 0

    amount = Essay::MAX_COUNT if amount.nil?
    user = enrolment.user
    # First compact in case a deleted tag set
    tag_list = product_version_feature_price.tags.compact.map(&:self_and_descendants).flatten.compact

    essay_list = Essay.includes(:tags).where(tags: { id: tag_list }).order(:position)
    if essay_list.count == 0
      EnrolmentsMailer.no_available_essay(enrolment).deliver_later if email_if_none && ENV['EMAIL_CONFIRMABLE'] != "false"
      return
    end
    # ensure they are unique
    # ensure randomness
    answer_list = []
    to_delete = [] # TODO: remove copies better way
    if enrolment.course.expiry_date.present? &&
       enrolment.course.expiry_date > Date.today.next_month
      remaining_days = (enrolment.course.expiry_date - Date.today.next_month).to_i
    else
      remaining_days = 365
    end
    if user.essay_responses.present?
      rem_essay_list = Essay.where.not(id: user.essay_responses.where(course_id: enrolment.course.id).pluck(:essay_id)).order(:position)
      if rem_essay_list.count < amount
        essay_list = rem_essay_list + Essay.where.not(id: rem_essay_list.ids).order(:id)
      else
        essay_list = rem_essay_list
      end
    end
    to_delete.each do |essay|
      essay_list.delete(essay)
    end

    if essay_list.count == 0
      EnrolmentsMailer.no_available_essay(enrolment).deliver_later if email_if_none && ENV['EMAIL_CONFIRMABLE'] != "false"
      return
    end
    if essay_list.count < amount && email_if_none
      EnrolmentsMailer.no_available_essay(enrolment).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false"
    end

    essay_list.each do |essay|
      answer_list.append(EssayResponse.create(user: user, essay: essay))
      break if answer_list.count == amount
    end
    if answer_list.count == 1
      ans_list_count = answer_list.count
    else
      ans_list_count = answer_list.count - 1
    end
    interval = remaining_days / ans_list_count
    answer_list.each_with_index do |answer, index|
      if index == answer_list.size - 1
        expiry = enrolment.course.expiry_date
      else
        expiry = Date.today.next_month + (interval * index)
      end
      answer_expiry_date = enrolment.try(:course).present? && enrolment.course.try(:city).present? ? ((expiry.midnight - 1.minute) + 1.day).strftime("%F %T.%N").in_time_zone(enrolment.course.try(:city).gsub("Sept-GAMSAT ","").gsub("Other","Melbourne")) : ((expiry.midnight - 1.minute) + 1.day).strftime("%F %T.%N").in_time_zone("Australia/Queensland")
      answer.update(expiry_date: answer_expiry_date, activation_date: Date.today, course_id: enrolment.course_id)
    end
  end

  def assign_mock_exam_essay
    tutor_id = course.staff_profiles.first.staff.id
    mock_exam_essay = MockExamEssay.find_or_create_by(course_id: course.id, user_id: user.id)
    mock_exam_essay.assigned_tutors = [tutor_id]
    mock_exam_essay.save
  end

  def active?
    acquired.present?
  end

  def product_version
    enrolment.course.product_version
  end

  def tags
    master_feature.product_version_feature_prices.find_by(product_version_id: product_version).tags
  end

  def deactivate
    purchase_item.destroy if purchase_item.present?
  end

  def activate(course, old_enrolment=nil, deactivate_feature=nil)
    if course.customable?
      if user.present? && user.address.present?
        custom_course = user.courses.includes(:product_version).where(product_versions: { course_type: ProductVersion::course_types['custom'] }, city: Course::CITIES[user.state.to_sym]).first
      else
        custom_course = user.courses.includes(:product_version).where(product_versions: { course_type: ProductVersion::course_types['custom'] }).first
      end
      order = self.enrolment.order
      if ['ongoing', 'registered'].include? order.status
        order.update(status: :paid, paid_at: Time.zone.now)
      end
      course = custom_course
    end
    if master_feature.private_tutoring? && self.enrolment.purchased_private_tutoring_session_enrol.present?
    #if master_feature.private_tutoring? && user.private_tutor_enrolment(course).present?
      #fl = user.private_tutor_enrolment(course)
      fl = self.enrolment.purchased_private_tutoring_session_enrol
      if deactivate_feature
        fl.update_attribute(:qty, fl.qty - self.qty)
      else
        fl.update_attribute(:qty, fl.qty + self.qty)
      end
      if fl.acquired.blank?
        update(acquired: DateTime.now)
      end
    elsif master_feature.essay? && user.active_essay_feature.present?
      # do nothing only assign essays
      # for GRAD-2257
      update(acquired: DateTime.now)
    else
      update(acquired: DateTime.now)
    end
    assign_essays if master_feature.essay?
    assign_mock_exam_essay if master_feature.live_exam?
    if self.product_version_feature_price.master_feature.name == "GamsatTextbookHardCopyFeature"
      enrolment.update(hardcopy: true, trial: false, trial_expiry: nil, paid_at: Time.zone.now)
    else
      enrolment.update(trial: false, trial_expiry: nil, paid_at: Time.zone.now)
    end
  end

  def deactivate_feature(course)
    deactivate if purchase_item.present?
    if master_feature.private_tutoring? && user.private_tutor_enrolment_course(course).present?
      fl = user.private_tutor_enrolment_course(course)
      fl.update(acquired: nil)
    elsif master_feature.essay? && user.active_essay_feature.present?
      user.essay_responses.limit(self.qty).destroy_all
      update(acquired: nil)
    else
      update(acquired: nil)
    end
  end

  def valid_for_purchase?
    true
  end

  def assign_hours_if_pv_changed(course_id, previous_enrolment_hours = 0)
    self.update(qty: ((self.acquired.present? ? self.qty : 0) + previous_enrolment_hours), acquired: previous_enrolment_hours > 0 ? Time.zone.now : self.acquired)
  end

  def allow_delete?
    master_feature.private_tutoring? || master_feature.essay? || master_feature.mcq_feature? || master_feature.exam_feature?
  end
end
