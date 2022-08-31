class UserEmailsController < ApplicationController
  layout 'layouts/dashboard', except: [:textbook_deliveries]
  before_action :authenticate_user!, except: [:search]
  before_action :ensure_not_student!, only: [:index, :edit, :update, :create, :destroy, :new, :index_filter]

  has_scope :by_product_line, only: [:download]
  has_scope :by_product_version, only: [:download]
  has_scope :by_course, only: [:download]
  has_scope :by_master_feature, only: [:download]
  has_scope :enroled, type: :boolean, only: [:download]
  has_scope :not_enroled, type: :boolean, only: [:download]
  has_scope :by_state, only: [:download]

  def index
    @type = params[:type]
    @stu_cat = params[:stu_cat]
    if params[:filterrific].present? && params[:filterrific][:by_course].present?
    ### GRAD2915 mismatch of product version ################
      course = Course.find_by(id: params[:filterrific][:by_course])
      if course.present?
        if params[:filterrific][:by_product_version]&.reject(&:blank?).present?
          unless params[:filterrific][:by_product_version]&.include?(course.product_version_id.to_s.presence)
            params[:filterrific][:by_course] = ""
          end
        end
      end
      #### GRAD2915 end #################
    end
    if params[:filterrific].present?
      if params[:filterrific][:filter_type] == "enquiry"
        enquiry_user_filterrify EnquiryUser  or return
        @all_users = @enquiry_filterrific.find
        @users = @all_users.uniq
        @users_type = "enquiry"
      elsif params[:filterrific][:filter_type] == "blog"
        blog_filterrify
        @all_users = @blog_filterrific.find
        @users = @all_users.uniq
        @users_type = "blog"
      else
        @product_versions = params[:filterrific][:by_product_line].present? ? ProductVersion.by_product_line(params[:filterrific][:by_product_line]).order(:name) : ProductVersion.none
        @cities = params[:filterrific][:by_state]&.reject(&:blank?) if params[:filterrific].present?
        if params[:filterrific][:by_product_line].blank?
          params[:filterrific][:by_product_version] = [""]
          params[:filterrific][:by_master_feature] = [""]
          params[:filterrific][:by_course] = ""
        else
          if params[:filterrific][:by_product_version]&.reject(&:blank?).blank?
            @master_features = MasterFeature.includes(:product_version_feature_prices).where(product_version_feature_prices: { product_version_id: @product_versions.pluck(:id) }).order(:name)
                #params[:filterrific][:by_product_version] = ProductVersion.all.pluck(:id)
          else
            @master_features = MasterFeature.by_product_version(params[:filterrific][:by_product_version]).order(:name)
          end
        end
        @courses = Course.by_product_version(params[:filterrific][:by_product_version]).order(:name)
        enrolled_filterrify policy_scope(User) or return
        @all_users = @enrolled_filterrific.find
        if params[:filterrific][:with_role] == "0" && params[:filterrific][:by_courses_status] == "1"
          #@courses = @courses.active_courses
          if params[:filterrific][:by_enroled] == "1"
            @all_users = @all_users.includes(enrolments: :course).where('(enrolments.trial = ? OR (enrolments.trial = ? AND enrolments.trial_expiry > ?)) AND orders.status !=? AND (courses.expiry_date >= ? OR courses.show_archived = ?)',false, true, Time.zone.now, 3, Time.zone.today.beginning_of_day, true).references(:courses)
          else
            @all_users = @all_users.includes(enrolments: :course).where('(enrolments.trial = ? OR (enrolments.trial = ? AND enrolments.trial_expiry > ?)) AND (courses.expiry_date >= ? OR courses.show_archived = ?)',false, true, Time.zone.now, Time.zone.today.beginning_of_day, true).references(:courses)
          end
        end
        @users = @all_users.uniq
        @users_type = "enrolled"
      end
    else
      if params[:filter_type] == 'enrolled' || (params[:filter_type].nil? && @type.nil?) || (params[:filter_type].nil? && (@type == "feature_upgrades" || @type == "student_profile" || @type == "student_contact" || @type == "student_profile_course" || @type == "student_survey"))
        enrolled_filterrify policy_scope(User) or return
        if @enrolled_filterrific.by_product_line.present?
          @product_versions = ProductVersion.by_product_line(@enrolled_filterrific.by_product_line).order(:name)
          @master_features = MasterFeature.by_product_line(@enrolled_filterrific.by_product_line).order(:name)
          if @enrolled_filterrific.by_product_version&.reject(&:blank?).blank?
            @master_features = MasterFeature.includes(:product_version_feature_prices).where(product_version_feature_prices: { product_version_id: @product_versions.pluck(:id) }).order(:name)
          else
            @master_features = MasterFeature.by_product_version(@enrolled_filterrific.by_product_version).order(:name)
          end
        else
          @product_versions = ProductVersion.none
          @master_features = MasterFeature.none
        end
        @cities = params[:filterrific][:by_state]&.reject(&:blank?) if params[:filterrific].present?
        @courses = Course.none
        enrolled_filterrify policy_scope(User) or return
        @all_users = @enrolled_filterrific.find
        if @enrolled_filterrific.with_role == "0" || @enrolled_filterrific.with_role == 0
          if @enrolled_filterrific.by_courses_status.blank? || @enrolled_filterrific.by_courses_status == 1
            if (@enrolled_filterrific.by_enroled == "1" || @enrolled_filterrific.by_enroled == 1)
               @all_users = @all_users.includes(enrolments: :course).where('(enrolments.trial = ? OR (enrolments.trial = ? AND enrolments.trial_expiry > ?)) AND orders.status !=? AND (courses.expiry_date >= ? OR courses.show_archived = ?)',false, true, Time.zone.now, 0, Time.zone.today.beginning_of_day, true).references(:courses)
            else
              @all_users = @all_users.includes(enrolments: :course).where('(enrolments.trial = ? OR (enrolments.trial = ? AND enrolments.trial_expiry > ?)) AND (courses.expiry_date >= ? OR courses.show_archived = ?)',false, true, Time.zone.now, Time.zone.today.beginning_of_day, true).references(:courses)
            end
          end
        end
        @users = @all_users.uniq
        @users_type = "enrolled"
      elsif params[:filter_type] == 'enquiry' || @type == "enquiry_profile"
        enquiry_user_filterrify EnquiryUser  or return
        @all_users = @enquiry_filterrific.find
        @users = @all_users.uniq
        @users_type = "enquiry"
      else
        @blog_filterrific = blog_filterrify
        @all_users = @blog_filterrific.find
        @users = @all_users.uniq
        @users_type = "blog"
      end
    end
    if @type == "student_profile"
      file_name = "User Details - #{Date.today}"
    elsif @type == "feature_upgrades"
      file_name = "Feature Upgrade Details - #{Date.today}"
    elsif @type == "student_contact"
      file_name = "Student Contact Details - #{Date.today}"
    elsif @type == "student_profile_course"
      file_name = "Student Profile & Course Details - #{Date.today}"
    elsif @type == "student_survey"
      file_name = "Student Survey Details - #{Date.today}"
    elsif @type == "enquiry_profile"
      file_name = "Enquiry Users Details - #{Date.today}"
    elsif @type == "blog_profile"
      file_name = "Blog Users Details - #{Date.today}"
    else
      file_name = "MCQ stats - #{Date.today}"
    end
    @users = @users.uniq.paginate(page: params[:page], per_page: 20)
    @all_users = @all_users.uniq
    respond_to do |format|
      format.html
      format.js
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="' + file_name + '.xlsx"'
      }
    end
  end

  # temp method to rebuild filter
  def index_filter

  end

  def textbook_deliveries
    @product_versions = ProductVersion.by_product_line("Gamsat").order(:name)
    @master_features = MasterFeature.includes(:product_version_feature_prices).where(product_version_feature_prices: { product_version_id: @product_versions.pluck(:id) }).order(:name)
    @courses = Course.by_product_version("").order(:name)
    condition_hash = condition_hash_params
    @enrolled_filterrific = initialize_filterrific(
        policy_scope(User),
        condition_hash,
        select_options: {
          with_role: current_user.options_for_role,
          product_versions: @product_versions ,
          master_features: @master_features,
          courses: @courses,
          sorted_by: User.options_for_sorted_by,
          option: TextbookDelivery.statuses,
          temporary_access: TextbookDelivery.options_for_temporary_access
        },
        default_filter_params: {}
    )  or return
    User.filter_params = @enrolled_filterrific
    @all_users = @enrolled_filterrific.find
    @all_users=@all_users.includes(:enrolments).where('enrolments.hardcopy =?' ,true).references(:enrolments)
    @all_users = @all_users.includes(enrolments: :course).where('(enrolments.trial = ? OR (enrolments.trial = ? AND enrolments.trial_expiry > ?)) AND (courses.expiry_date >= ? OR courses.show_archived = ?)',false, true, Time.zone.now, Time.zone.today.beginning_of_day, true).references(:enrolments,:courses)
    @all_users = @all_users.includes(:enrolments).select('users.*, enrolments.paid_at').order('enrolments.paid_at DESC')
    @users = @all_users.uniq.paginate(page: params[:page], per_page: 20)
    @all_users = @all_users.uniq
    if params[:filterrific].present? && params[:filterrific][:temporary_access].present? && params[:filterrific][:temporary_access] == "false"
      user_ids = TextbookDelivery.where(temporary_access_granted: true).pluck(:user_id)
      @users = User.where(id: @users.pluck(:id))
      @users = @users.where.not(id: user_ids).paginate(page: params[:page], per_page: 20)
    end
    # if params[:search].present?
    #   keyword = "%#{params[:search]}%"
    #   @users = @users.where("first_name ILIKE ? OR last_name ILIKE ? OR email ILIKE ?", keyword,keyword, keyword).paginate(page: params[:page], per_page: 20)
    # end

    # if params[:textbook_status].present?
    #   @users = @users.includes(:textbook_deliveries).where('textbook_deliveries.status = ?', params[:textbook_status].to_i).references(:textbook_deliveries).paginate(page: params[:page], per_page: 20)
    # end

    # if params[:temporary_access].present?
    #   @users = @users.includes(:textbook_deliveries).where('textbook_deliveries.temporary_access_granted = ?', ActiveRecord::Type::Boolean.new.type_cast_from_user(params[:temporary_access])).references(:textbook_deliveries).paginate(page: params[:page], per_page: 20)
    # end

    if params[:date_of_order].present?
      @users = @users.includes(:enrolments).where('DATE(enrolments.paid_at) = ? && enrolments.hardcopy=?', Date.parse(params[:date_of_order]), true).references(:enrolments).paginate(page: params[:page], per_page: 20)
    end
    if params[:column].present?
      user = User.find_by(id: params[:user_id])
      if user
        order_id = user.try(:current_enrolment).try(:order).try(:id)
        # textbook_deliveries = user.textbook_deliveries.find_by(enrolment_id: user.try(:current_enrolment).try(:id),order_id: order_id)
        textbook_deliveries = user.try(:textbook_deliveries).last if user.try(:textbook_deliveries).present?
        key = params[:column]
        if key == "status"
          value = params[:value].to_i
        else
          value = params[:value]
        end
        if !textbook_deliveries.present?
          textbook_deliveries = user.textbook_deliveries.create(enrolment_id: user.try(:current_enrolment).try(:id),order_id: order_id)
        end
        textbook_deliveries.update_attribute(key, value)
      end
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def condition_hash_params
    if params[:filterrific].present?
      condition_hash = params[:filterrific].merge!({ filter_type: "enrolled",
            with_start_purchase: "",
            with_end_purchase: "",
            with_role: "0",
            by_courses_status: "1",
            by_enroled: "0",
            by_product_line: "Gamsat",
            by_subscription: "",
            by_state: [""],
            by_product_version: [""],
            by_master_feature: ["26"],
            by_course: ""})
    else
      condition_hash = { filter_type: "enrolled",
            with_start: "",
            with_end: "",
            with_start_purchase: "",
            with_end_purchase: "",
            with_name: "",
            with_role: "0",
            by_courses_status: "1",
            by_enroled: "0",
            by_product_line: "Gamsat",
            by_subscription: "",
            by_state: [""],
            by_product_version: [""],
            by_master_feature: ["26"],
            by_course: "",
            sorted_by: ""}
    end
    return condition_hash
  end

  def enrolled_filterrify(collection)
    if params[:filterrific] && params[:filterrific][:with_role] != "0"
      default_filter_params = {}
    else
      default_filter_params = {with_role: 0}
    end
    @enrolled_filterrific = initialize_filterrific(
        collection,
        params[:filterrific],
        select_options: {
          with_role: current_user.options_for_role,
          with_account_status: User.statuses.to_a.map{|s| [s.first.capitalize, s.last]},
          with_specialty: ['Essay Marker', 'GC Tutor', 'Private Tutor'],
          product_versions: @product_versions,
          master_features: @master_features,
          by_state: @cities,
          courses: @courses,
          sorted_by: User.options_for_sorted_by
        },
        default_filter_params: default_filter_params,
        persistence_id: true
    )
    User.filter_params = @enrolled_filterrific
    @enrolled_filterrific
  end

  def filterrify(collection)
    if params[:filterrific] && params[:filterrific][:with_role] != "0"
      default_filter_params = {}
    else
      default_filter_params = {with_role: 0, by_users: 1, by_enroled: 1}
    end

    @filterrific = initialize_filterrific(
        collection,
        params[:filterrific],
        select_options: {
          sorted_by: User.options_for_sorted_by,
          with_role: current_user.options_for_role,
          product_versions: @product_versions ,
          master_features: @master_features,
          courses: @courses
        },
        default_filter_params: default_filter_params
    )
    User.filter_params = @filterrific if params[:filterrific].present?
    @filterrific
  end

  def enquiry_user_filterrify(collection)
    @enquiry_filterrific = initialize_filterrific(
        EnquiryUser,
        params[:filterrific],
        select_options: {
          sorted_by_enquiry: EnquiryUser.options_for_sorted_by
        }
      )
    EnquiryUser.filter_params = @enquiry_filterrific
  end

  def enquiry_filterrify(collection)
    @filterrific = initialize_filterrific(
        EnquiryUser,
        params[:filterrific],
        select_options: {
          sorted_by: EnquiryUser.options_for_sorted_by,
          with_role: current_user.options_for_role,
          product_versions: [] ,
          master_features: [],
          courses: []
        }
      )
  end

  def blog_user_filterrify
    initialize_filterrific(
      MailingListSubscription,
      params[:filterrific],
      select_options: {
        sorted_by: MailingListSubscription.options_for_sorted_by,
        with_role: current_user.options_for_role,
        product_versions: [] ,
        master_features: [],
        courses: []
      }
    )
  end


  def blog_filterrify
    @blog_filterrific = initialize_filterrific(
      MailingListSubscription,
      params[:filterrific],
      select_options: {
        sorted_by_blog: MailingListSubscription.options_for_sorted_by,
        with_role_blog: current_user.options_for_role
      }
    )
    MailingListSubscription.filter_params = @blog_filterrific
  end

  def reset_textbook_access
    @user = User.find(params[:id])
    # @book = Textbook.includes(:taggings).where(taggings: {tag_id: feature_tag_ids('TextbookFeature')}).order(:title)
  end

  def update_book_access
    user_id = params[:id]
    if params[:book_id].present?
      book_ids = params[:book_id]
      book_ids = Textbook.to_reset.pluck(:id) if book_ids.reject(&:empty?).blank?

      book_ids.each do |id|
        @print = TextbookPrint.find_by(user_id: user_id, textbook_id: id)
        @print.update(print_count: 1) if @print
      end
    end
    flash[:notice] = "Textbook printing access was reset successfully."
    render js: "document.location = '#{reset_exams_user_path(user_id)}'"
    #format.js "document.location = '#{reset_exams_user_path(user_id)}'"
  end


  def mass_send
    subject = params[:email_users][:subject]
    content = params[:email_users][:content]
    if params[:send_all].present?
      if params[:email_users][:all_user_ids].present?
        user_ids = params[:email_users][:all_user_ids].split(" ")
        e_user = false
      else
        if params[:email_users][:all_blog_user_ids].present?
          user_ids = params[:email_users][:all_blog_user_ids].split(" ")
          blog_mail = true
        else
          user_ids = params[:email_users][:all_euser_ids].split(" ")
        end
        e_user = true
      end
    else
      if params[:email_users][:user_ids].present?
        user_ids = params[:email_users][:user_ids]
        e_user = false
      else
        user_ids = params[:email_users][:euser_ids]
        e_user = true
      end
    end

    if subject.present? && content.present? && user_ids.present?
      MassEmailJob.perform_later(user_ids, subject, content, e_user, blog_mail)
      flash[:notice] = 'Emails enqueued successfully'
    else
      message =''
      message += 'Subject must be present ' unless subject.present?
      message += 'Email content must be present ' unless content.present?
      message += 'No users selected' unless user_ids.present?
      flash[:error] = message.html_safe
    end

    redirect_to user_emails_path
  end

  def download
    @filterrific = initialize_filterrific(
      User,
      params[:filterrific],
      select_options: {
      }
    ) or return

    @users = @filterrific.find
    respond_to do |format|
      format.xls
      format.csv { generate_csv_report(@users) }
    end
  end

  def verify_transactions
    if params[:user_ids].present?
      @orders = Order.where('status IN (?) AND user_id IN (?)', [0,1], params[:user_ids])
    end
  end

  def destroy_incomplete_transactions
    orders = Order.where(id: params[:order_ids].split(' '))
    if orders.destroy_all
      msg = "Incomplete transactions deleted successfully!!"
    else
      msg = "Error in deleting incomplete transactions, please contact concerned person!"
    end
    redirect_to user_emails_path, notice: msg
  end

  private

  def generate_csv_report(data)
    self.response.headers["Content-Type"] ||= 'text/csv'
    self.response.headers["Content-Disposition"] = "attachment; filename=users.csv"
    self.response.headers["Content-Transfer-Encoding"] = "binary"

    self.response_body = build_csv_enumerator(data)
  end

  def build_csv_enumerator(scope)
    Enumerator.new do |y|
      CsvBuilder::UserCsvBuilderService.new(scope, y).call
    end
  end

  def ensure_not_student!
    redirect_to root_url if current_user.nil? or current_user.student?
  end
end
