class Order < ApplicationRecord
  # t.string   "reference_number"
  # t.decimal  "redundant_total_cost", precision: 8, scale: 2
  # t.decimal  "redundant_method_fee", precision: 8, scale: 2
  # t.string   "brain_tree_reference"
  # t.datetime "paid_at"
  # t.integer  "user_id"
  # t.datetime "created_at", null: false
  # t.datetime "updated_at", null: false
  # t.int   "purchase_method"
  # t.integer  "authoriser_id"
  # t.integer  "status",



  belongs_to :user
  belongs_to :creator, class_name: 'User', foreign_key: "creator_id", optional: true
  belongs_to :authoriser, class_name: 'User', optional: true
  has_many :purchase_items, dependent: :destroy
  has_one :generated_promo, class_name: 'Promo',
                            foreign_key: 'generated_from_id',
                            dependent: :destroy
  validates :reference_number, presence: true, uniqueness: true
  # validates :user, presence: true
  enum status: [:ongoing, :pending, :paid, :free, :trial, :subscription, :registered]
  enum purchase_method: [:direct_deposit, :braintree, :paypal,
                         :direct_deposit_classic]

  enum subscription_status: [:active, :canceled, :past_due, :waiting_for_payment, :expired]
  # Note order is there to reflect order given by braintree website, on databse witing_for_payment is default

  before_validation(on: :create) do
    set_reference_number
  end


  filterrific(
    available_filters: [
      :with_purchase,
      :with_reference,
      :with_keyword
    ]
  )

  scope :with_purchase, -> (reference_number){ where "reference_number ILIKE :reference_number", reference_number: "%#{reference_number}%" }

  scope :with_reference, -> (reference){ where "reference_number ILIKE :reference OR brain_tree_reference ILIKE :reference OR reference_number ||' '|| brain_tree_reference ILIKE :reference OR brain_tree_reference ||' '|| reference_number ILIKE :reference", reference: "%#{reference}%" }


  scope :with_keyword, -> (term){
    where("((users.first_name ILIKE ?) OR (users.last_name ILIKE ?) OR (users.username ILIKE ?) OR (lower(concat(users.first_name,' ',users.last_name)) ILIKE ?)  OR (reference_number ILIKE ?))",term,term,term,term,term).references(:users) }
  # ongoing current cart, pending there is a direct transfer, paid has been paid
  has_many :orders_promos
  has_many :promos, through: :orders_promos

  def below_minimum_spend?
    total_initial_cost < BigDecimal.new('290.00')
  end

  def promo_refund_amount
    return 0 if generated_promo.nil?
    generated_promo.orders.where(status:
      Order.statuses[:paid]).count * BigDecimal.new('0.05') * total_cost
  end

  def update_promo!
    if paid?
      if generated_promo.nil?
        expiry_date = self.purchase_items.first.purchasable.course.expiry_date if self.purchase_items.present?
        if expiry_date && (expiry_date < Date.today)
          expiry_date = Date.today + 1.week
        end
        self.generated_promo = Promo.new(
          user: user,
          stackable: false,
          strategy: :percentage,
          amount: '10',
          generated_from: self,
          used_times: 100,
          expiry_date: expiry_date,
          name: "Discount Code"
        )
        generated_promo
        save
        generated_promo.generate_token!
      end
      return
    else
      return if generated_promo.nil?
      generated_promo.destroy
      return save
    end
  end

  def purchased_course_by_pv_type(pv_course_types)
    self.purchase_items.joins(enrolment: [course: :product_version]).where("product_versions.course_type IN (?)", pv_course_types)
  end

  def set_reference_number
    self.reference_number = rand(36**6).to_s(36)
  end

  def recalculate_discounts!
    purchase_items.reload.each do |item|
      item.discount_applied = 0
    end
    promos.each { |promo| promo.calculate! purchase_items }
  end

  def total_cost
    total = 0
    recalculate_discounts!

    purchase_items.each do |item|
      total += item.initial_cost
      total += item.added_gst
      total += item.shipping_cost
      total += item.method_fee if item.method_fee.present?
      total -= item.discount_applied
      total = total
    end
    total
  end

  def total_initial_cost
    total = 0

    purchase_items.each do |item|
      total += item.initial_cost if item.initial_cost
    end
    total
  end

  def total_added_gst
    total = 0

    purchase_items.each do |item|
      total += item.added_gst
    end
    total
  end

  def total_discount
    total = 0
    # recalculate_discounts!
    purchase_items.each do |item|
      total += item.discount_applied
    end
    total
  end

  def order_subtotal
    total = 0
    recalculate_discounts!

    purchase_items.each do |item|
      total += item.initial_cost
      total += item.added_gst
      total -= item.discount_applied
      total = total
    end
    total
  end

  def total_shipping_cost
    total = 0
    purchase_items.each do |item|
      total += item.shipping_cost
    end
    total
  end

  def total_method_fee
    total = 0
    purchase_items.each do |item|
      total += item.method_fee if item.method_fee.present?
    end

    total
  end

  def send_essay_mail
    purchase_items.each do |purchase|
      if purchase.purchasable_type == "Enrolment"
        ids = purchase.purchasable.course.staff_profiles.pluck(:id)
        course_id = purchase.purchasable.course.try(:id)
        essay_feat = purchase.purchasable.course.product_version.product_version_feature_prices.where(is_default: true).select{|a| a.master_feature.essay? }.present?

      else
        ids = purchase.purchasable.enrolment.course.staff_profiles
        course_id = purchase.purchasable.enrolment.course.try(:id)
        essay_feat = purchase.purchasable.master_feature.essay?
      end

      if essay_feat
        dates = user.essay_responses.includes(:course, :essay, essay_tutor_response: [staff_profile: [:staff]]).where(courses: { id: course_id }).pluck(:expiry_date)

        @responses = EssayResponse.includes(course: :staff_profiles).where('courses.expiry_date > ? AND essay_responses.status IN (?) AND essay_responses.expiry_date > ?', Time.zone.now.in_time_zone("Australia/Melbourne"), [0,1], Time.zone.now.in_time_zone("Australia/Melbourne")).references(:courses).includes(:user).where.not(users: { confirmed_at: nil })

        ids.each do |id|
          dates.each do |date|
            res_count = @responses.where(staff_profiles: {id: id}, expiry_date: date).count
            if ((res_count != 0) && (res_count % 5 == 0) || res_count > 25)
              EssayResponseMailer.essay_marking_reminder(res_count, date.strftime("%d/%m/%Y"), id).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false"
            end
          end
        end
      end
    end

  end

  def self.send_essay_reminder_mail
    Order.includes(purchase_items: [enrolment: :course]).where("courses.expiry_date > ?", Time.zone.now).references(:courses).each do |order|
      user = order.user
      order.purchase_items.each do |purchase|
        if purchase.purchasable_type == "Enrolment"
          ids = purchase.purchasable.course.staff_profiles.pluck(:id) rescue nil
          course_id = purchase.purchasable.course.try(:id) rescue nil
          essay_feat = purchase.purchasable.course.product_version.product_version_feature_prices.where(is_default: true).select{|a| a.master_feature.essay? }.present? rescue nil

        else
          ids = purchase.purchasable.enrolment.course.staff_profiles rescue nil
          course_id = purchase.purchasable.enrolment.course.try(:id) rescue nil
          essay_feat = purchase.purchasable.master_feature.essay? rescue nil
        end

        if essay_feat
          dates = user.essay_responses.includes(:course, :essay, essay_tutor_response: [staff_profile: [:staff]]).where(courses: { id: course_id }).pluck(:expiry_date) rescue nil

          @responses = EssayResponse.includes(course: :staff_profiles).where('courses.expiry_date > ? AND essay_responses.status IN (?) AND essay_responses.expiry_date > ?', Time.zone.now.in_time_zone("Australia/Melbourne"), [0,1], Time.zone.now.in_time_zone("Australia/Melbourne")).references(:courses).includes(:user).where.not(users: { confirmed_at: nil })

          if (!(ids.nil?) || !(ids.blank?))
            ids.each do |id|
              if (!(dates.nil?) || !(dates.blank?))
                dates.each do |date|
                  res_count = @responses.where(staff_profiles: {id: id}, expiry_date: date).count
                  if (((res_count != 0) && (res_count % 5 == 0) || res_count > 25) && ((date - 1.month) == Date.today))
                    EssayResponseMailer.essay_marking_reminder(res_count, date.strftime("%d/%m/%Y"), id).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false"
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  def set_redundant_cost
    self.redundant_total_cost = total_cost
    self.redundant_method_fee = total_method_fee
  end

  def student_course
    enrolment_items = purchase_items.where(purchasable_type: 'Enrolment')
    purchase_addons_items = purchase_items.where(purchasable_type: 'FeatureLog')
    enrolment = if enrolment_items.present?
                  enrolment_items.first.purchasable
                elsif purchase_addons_items.present?
                  purchase_addons_items.first.purchasable.enrolment
                else
                  user.paid_enrolments.first
                end

    enrolment = user.paid_enrolments.first if enrolment.nil?
    @course = enrolment.course if enrolment.present?
    if @course.trial_enabled || @course.expired?
      custom_course = user.courses.includes(:product_version).where(product_versions: { course_type: ProductVersion::course_types['custom'] }, city: Course.cities[@course.city]).first
    end
    @course = custom_course.present? ? custom_course : @course
  end

  def student_product_version
    ' ' unless student_course.present?
    # As we're dealing with braintree API adding extra error checking,
    # not sure if they handle nil values
    student_course.product_version.name
  end

  def contains_online_webminar?
    is_webminar = false
    self.purchase_items.each do|pi|
      if pi.purchasable_type == "FeatureLog"
        mf_name = pi.purchasable.product_version_feature_price.master_feature.name
        is_webminar = true if mf_name == "GamsatAttendanceTutorialsFeature"
        break if is_webminar
      end
    end
    is_webminar
  end

  def purchase_details
    if self.purchase_items.count == 1
      @feature_log = self.purchase_items.first.purchasable_type == "FeatureLog"
      if @feature_log
        @title = self.purchase_items.first.purchasable.try(:product_version_feature_price).try(:master_feature).try(:name)
      else
        @title = self.purchase_items.first.purchasable.course.name
      end
    else
      @title = self.purchase_items.map{|i| i.purchasable_type == 'FeatureLog'? i.purchasable.product_version_feature_price.master_feature.name : self.purchase_items.last.purchasable.course.name }.compact
      @title = @title.join(', ')
    end
  end

  def quantity_details
    @quantity = []
    if self.purchase_items.count == 1
      @feature_log = self.purchase_items.first.purchasable_type == "FeatureLog"
      if @feature_log
        if self.purchase_items.first.purchasable.product_version_feature_price.master_feature.essay? || self.purchase_items.first.purchasable.product_version_feature_price.master_feature.private_tutoring?
          @quantity << self.purchase_items.first.purchasable.product_version_feature_price.qty
        elsif purchase_items.first.purchasable.qty.present?
          @quantity << purchase_items.first.purchasable.qty
        else
          @quantity << 1
        end
      else
        @quantity << "NA"
      end
    else
      self.purchase_items.each do |i|
        if i.purchasable_type == 'FeatureLog'
          if i.purchasable.product_version_feature_price.master_feature.essay? || i.purchasable.product_version_feature_price.master_feature.private_tutoring?
            @quantity << i.purchasable.product_version_feature_price.qty
          else
            @quantity << 1
          end
        else
          @quantity << "NA"
        end
      end
    end
    @quantity
    @quantity = @quantity.join(', ')
  end


  def suspend!
    enrolment_items = purchase_items.select do |purchase|
      purchase.purchasable.class.name == 'Enrolment'
    end

    enrolment_items.each do |purchase|
      purchase.purchasable.suspend!
    end
  end

  def add_promo(token)
    ActiveRecord::Base.transaction do
      promo = Promo.find_by_token(token)

      # Promo is invalid
      return false if promo.nil?

      # Promo is not stackable and there are existing promos
      if !promo.stackable? && promos.count > 0
        errors.add(:base, 'One of the discounts were not stackable')
        return false
      end

      # Can't use the same promo code multiple times
      if promos.where(id: promo.id).present?
        errors.add(:base, "Can't use the same promo code multiple times")
        return false
      end

      if promo.purchase_count>=promo.used_times
        errors.add(:base, 'Promo code used limit exceeds')
        return false
      end

      # Can't mix stackable and unstackable promos
      # (unstackable takes precedence)
      if promos.where(stackable: false).count > 0
        errors.add(:base, 'One of the discounts were not stackable')
        return false
      end

      promos << promo
    end
    true
  end

  def other_orders
    user.orders.where(status: Order.statuses['paid']).where.not(id: id)
  end

  def remove_purchase_items
    purchase_items.each do |purchase_item|
      next if purchase_item.purchase_description.to_s.include?('Custom course for Free trail')

      purchasable_item = purchase_item.purchasable

      if purchase_item.destroy
        promos.destroy_all if purchase_items.empty?
        if purchase_item.purchasable_type == 'FeatureLog' && purchase_item.purchasable.present? && purchase_item.purchasable.allow_delete?
          purchasable_item.destroy
        end
      end
    end
  end

  def contains_full_course?
    purchase_items.where(purchasable_type: 'Enrolment').each do |purchase_item|
      course = purchase_item.purchasable.course
      return true if course&.paid_enrolments_with_pending&.count.to_i >= course&.class_size.to_i
    end

    false
  end

  def full_course_names
    purchase_items.where(purchasable_type: 'Enrolment').map { |purchase_item|  purchase_item.purchasable.course&.name }.compact
  end

  def complete_purchase(course=nil, old_enrolment=nil, deactivate_feature=nil, manually_completed = false, needs_activation = false, size = nil)
    # Goes through and enrols everyone once payment finalised
    self.paid_at = Time.zone.now
    update_promo!

    if !manually_completed || needs_activation
      purchase_items.each do |purchase|
        method_fee = if braintree?
                       paypal_addon * purchase.total_item_cost
                     else
                       0
                     end
        purchase.update(method_fee: method_fee)
        if (course.present? && course.customable?)
          purchase.purchasable_type == "FeatureLog" ? purchase.purchasable.activate(user.active_course, old_enrolment,deactivate_feature) : purchase.purchasable.activate(user.active_course, old_enrolment,deactivate_feature)
          user.update_attribute(:payment_flow_step, Rails.application.routes.url_helpers.update_contact_user_path(user))
        else
          user.active_course = course unless user.active_course.present?
          if old_enrolment.present? && (old_enrolment.state == "Unenrolled")
            user.active_course = course
          end
          unless user.active_course.present? && !(purchase_items.pluck(:purchasable_type).uniq.count > 1)
            user.active_course = purchase.purchasable.course
          end
          purchase.purchasable.activate(user.active_course, old_enrolment,deactivate_feature)
        end
        set_signin_count_for_enrolment(purchase)
      end
    end

    #send_essay_mail if user.confirmed_at.present?

    set_redundant_cost

    unless free? || (size.present? && size.negative?)
      if ENV['EMAIL_CONFIRMABLE'] != "false"
        if user.confirmed_at.present?
          OrdersMailer.specific_addon_purchase(self).deliver_later if contains_online_webminar?
          OrdersMailer.student_tax_invoice(self).deliver_later
          customise_email_template_for_master_feature
        else
          user.mail_pendings.create(order_id: self.id, category: "OrdersMailer", method: 'student_tax_invoice(order)', status: 0)
        end
      end

      if purchase_items.select do |pi|
        pi.purchasable.class.name == 'Enrolment'
      end.empty?
        course = student_course
        if course.present? && ENV['EMAIL_CONFIRMABLE'] != "false"
          if user.confirmed_at.present?
            OrdersMailer.staff_complete_purchase(self).deliver_later
          else
            user.mail_pendings.create(order_id: self.id, category: "OrdersMailer", method: 'staff_complete_purchase(order)', status: 0)
          end
        end
      end
    end

    course_enrol = student_course

    if ENV['EMAIL_CONFIRMABLE'] != "false"
      CoursesMailer.course_full_notification(course_enrol).deliver_later if course_enrol.course_full? && !course_enrol.expired?
      CoursesMailer.course_full_alert(course_enrol).deliver_later if course_enrol.full_alert?
    end

    if course_enrol.visible_to_student && course_enrol.notify_student && course_enrol.textbooks.present?
      CoursesMailer.create_time_timetable_mail(course_enrol, self.user).deliver_later
    end

    promos.each do |promo|
      unless promo.generated_from.nil?
        OrdersMailer.promo_applied(promo).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false"
      end
    end
    save
    remove_user_free_courses_once_paid_available
    update_user_status_after_purchase_of_course
  end

  def customise_email_template_for_master_feature
    unless self.purchase_items.pluck(:purchasable_type).include?("Enrolment")
      master_feature_ids = []
      self.purchase_items.each do |purchase_item|
        if purchase_item.purchasable_type == "FeatureLog"
          pvfp = purchase_item.try(:purchasable).try(:product_version_feature_price)
          master_feature_ids << pvfp.master_feature_id
        end
      end
      email_templates = EmailCustomise.includes(:master_features, :courses, :product_versions).where("master_features.id IN (?) AND courses.id IS NULL AND product_versions.id IS NULL", master_feature_ids).references(:master_features)
      email_templates.each do |email_template|
        if email_template.publish?
          OrdersMailer.customise_master_feature_mail(self, email_template).deliver_later
        end
      end if email_templates.present?
    end
  end

  # For Manually added master feature email templates
  def customise_email_template_for_master_feature_manual(master_feature)
    email_templates = EmailCustomise.includes(:master_features, :courses, :product_versions).where("master_features.id = ? AND courses.id IS NULL AND product_versions.id IS NULL", master_feature.id).references(:master_features)
    email_templates.each do |email_template|
      if email_template.publish?
        OrdersMailer.customise_master_feature_mail(self, email_template).deliver_later
      end
    end if email_templates.present?
  end

  def set_discount_if_expired_exists current_user
    if current_user.courses.includes(:product_version).where.not("product_versions.course_type IN (?)", [0,1,2,3,9,10,11]).references(:product_versions).map(&:expired?).include?(true)
      self.add_promo(Promo::B_IR_PROMOCODE) if self.purchased_course_by_pv_type([2,3,9]).present?
      self.add_promo(Promo::B_PROMOCODE) if self.purchased_course_by_pv_type([4,5,6,7,8]).present?
    end
  end

  def set_signin_count_for_enrolment purchase
    if purchase.purchasable_type == 'Enrolment'
      enrolment = purchase.purchasable
      enrolment.update(signin_count_enrolment: user.sign_in_count)
      enrolment.update(total_online_time_enrolment: user.total_online_time)
    end
  end

  def update_user_status_after_purchase_of_course
    self.user.update_attribute(:status, User.statuses['activated'])
    if ENV['EMAIL_CONFIRMABLE'] != "false"
      OrdersMailer.unsuccessful_purchase(self).deliver_later unless save || self.creator.present? && (self.creator.admin? || self.creator.superadmin? || self.creator.manager?)
    end
  end

  def remove_user_free_courses_once_paid_available
    if user.orders.paid.present? && paid?
      free_enrolments = []
      user.orders.includes(:purchase_items)
          .where("purchase_items.purchasable_type = 'Enrolment' AND status IN (3, 6)").references(:purchase_items)
          .each do |o|
        o.purchase_items.each do |pi|
          e_ids = self.purchase_items.map{|p| p.purchasable.try(:enrolment_id) }.compact.uniq
          free_enrolments.push(pi.purchasable_id) if pi.purchasable_type == 'Enrolment' && e_ids.exclude?(pi.purchasable_id)
        end
      end

      es = Enrolment.where(id: self.purchase_items.map{|p| p.purchasable.try(:enrolment_id) || p.purchasable_id }.compact.uniq)
      user.update_attribute(:active_course_id, es.first.course_id) if es.present?

      Enrolment.where.not(state: 'Unenrolled').where(id: free_enrolments).find_each do |e|
        e.update(state: 'Unenrolled')
        EnrolmentsMailer.unenrollment_notification(e).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false" && e.paid_at.present?
      end
    end
  end

  def braintree_transaction(nonce, device_data)

    result = Braintree::Transaction.sale(
        amount: (total_cost + total_cost * paypal_addon).round(2).to_s,
        payment_method_nonce:  nonce,
        options: {
            paypal: {
                description: reference_number,
                custom_field: user.full_name,
            },
            submit_for_settlement: true,
        },
        billing: {
            first_name: user.first_name,
            last_name: user.last_name,
        },
        customer: {
            first_name: user.first_name,
            last_name: user.last_name,
            id: user.id,

        },
        custom_fields: {
          order_reference: reference_number,
          product_version: student_product_version,
        },
        device_data: device_data
    )

    if result.success?
      update(brain_tree_reference: result.transaction.id, paid_at: Time.now)
      braintree!
      paid!
      complete_purchase
    end
    result
  end

  def create_braintree_subscription(nonce)
    return false if !confirm_valid_subscription
    product_version = purchase_items.first.purchasable.course.product_version
    price = product_version.subscription_price
    expiry = purchase_items.first.purchasable.course.expiry_date
    never_expire = expiry.nil?
    result = Braintree::Subscription.create(
      plan_id: "2pyw",
      payment_method_nonce: nonce,
      price: price,
      never_expires: never_expire,
      number_of_billing_cycles: num_billing(expiry),
      descriptor: {
          name: "GradReady   * Course  ",
      }
    )
    if result.success?
      update(brain_tree_reference: result.subscription.id, paid_at: Time.now)
      subscription!
      waiting_for_payment!
      paid!
      complete_purchase
    end
    result
  end

  def num_billing(expiry_date)
    # Returns number of months person should be billed
    if(expiry_date.nil?)
      nil
    else
      (expiry_date.year * 12 + expiry_date.month) - (Time.zone.today.year * 12 + Time.zone.today.month).floor
    end
  end

  def return_braintree_customer_id
    # Returns the braintree customer id, and creates a customer if there isn't one
    begin
      result = Braintree::Customer.find(user_id.to_s)
      return result.id

    rescue Braintree::NotFoundError
      result = Braintree::Customer.create(
          first_name: user.first_name,
          last_name: user.last_name,
          id: user_id.to_s,
          email: user.email
      )
    else
      return nil
    end
    if result.success?
      customer = result.customer
    else
      return nil
    end
    return customer.id
  end

  def confirm_valid_subscription
    # Confirms that the order can accept a subscription
    enrolment = purchase_items.first.purchasable unless purchase_items.first.nil?

    # Returns true only if the cart only contains one enrolment that is set as subscribable
    purchase_items.count == 1 && !enrolment.nil? && enrolment.class == Enrolment && enrolment.course.product_version.subscribable?
  end

  def paypal_addon
    0.019
  end

  def can_checkout?
    purchase_items.all? { |item| item.purchasable.try(:valid_for_purchase?) }
  end
  
  def can_be_purchased?
    can_purchase = true
    all_items = self.reload.purchase_items.where(initial_cost: 0)
    if all_items.present?
      no_cost_feature_logs = all_items.joins(enrolment: [feature_logs: :product_version_feature_price]).where('purchase_items.purchase_description NOT LIKE (?) AND product_version_feature_prices.price = ?', 'Custom course for Free trail%', 0)
      can_purchase = false if no_cost_feature_logs.present?
    end
    can_purchase
  end

  def update_course_detail
    enrolment_items = purchase_items.select{|purchase| purchase.purchasable.class.name == "Enrolment"}
    if enrolment_items.empty? && user.has_free_trial_only?
      custom_order = user.orders.includes(:purchase_items).where('purchase_items.purchase_description LIKE ? ', '%Custom course for Free trail%').references(:purchase_items).first
      enrolment = user.enrolments.includes(:order).find_by(orders: { id: custom_order.try(:id) })
    else
      enrolment = user.enrolments.includes(:order).find_by(orders: { id: id })
    end
    if enrolment.present?
      enrolment.update_attribute(:course_id, self.course_id)
      self.update_attribute(:course_id, nil)
    end
  end

  def fetch_show_path(different_course=nil)
    if different_course.present?
      Rails.application.routes.url_helpers.course_details_user_path(id: user.id, different_course: true)
    else
      Rails.application.routes.url_helpers.course_details_user_path(id: user.id)
    end
  end
end
