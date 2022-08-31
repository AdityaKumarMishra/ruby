class EnrolmentsMailer < ApplicationMailer
  require 'open-uri'
  helper ApplicationHelper
  helper ProductVersionsHelper
  helper PagesHelper


  default from: "GradReady <student.care@gradready.com.au>"

  def student_new_customise_enrolment(enrolment, email_template)
    @email_template = email_template
    @order = enrolment.purchase_item.order
    @student = @order.user
    if @email_template.attachment_name_file_name.present?
      attachments[@email_template.attachment_name_file_name]  = {
        mime_type: 'application/pdf',
        content: open(@email_template.attachment_name.url).read
      }
      # unless File.exist?("#{Rails.root}/public/attachment_#{@email_template.id}.pdf")
      #   file = open(@email_template.attachment_name.url)
      #   IO.copy_stream(file, "#{Rails.root}/public/attachment_#{@email_template.id}.pdf")
      # end
      # attachments[@email_template.attachment_name_file_name] = File.read("#{Rails.root}/public/attachment_#{@email_template.id}.pdf")
    end
    mail(to: check_environment ? DEFAULT_TO : @student.email, subject: "#{@email_template.email_subject}")
  end

  def student_new_enrolment(enrolment)
    @course = enrolment.course
    @enrolment = enrolment
    @product_line_type = enrolment.product_line_type
    @order = enrolment.purchase_item.order
    @student = @order.user
    @other_orders = @order.other_orders
    @reference_number = @order.reference_number
    mail(to: check_environment ? DEFAULT_TO : @student.email, subject: "Welcome to #{@enrolment.course.name}")
  end

  def student_new_free_trail_enrolment(enrolment)
    @enrolment = enrolment
    @trial_course = enrolment.course
    @product_line_type = enrolment.product_line_type
    @order = enrolment.purchase_item.order
    @student = @order.user
    @other_orders = @order.other_orders
    @reference_number = @order.reference_number
    @product_line = @trial_course.product_version.type.underscore.split("_")[0]
    mail(to: check_environment ? DEFAULT_TO : @student.email, subject: "Welcome to #{@enrolment.course.name} Free Trial")
  end

  def staff_new_enrolment(enrolment)
    @enrolment = enrolment
    @course = enrolment.course
    @course_type = @course.course_type
    @payment_email = "payment@gradready.com.au"
    @order = enrolment.purchase_item.order
    @student = @order.user
    @braintree_number = @order.brain_tree_reference
    @other_orders = @order.other_orders
    @reference_number = @order.reference_number
    @product_version_name = @course.product_version.name
    if @order.direct_deposit?
      method = "DD Paid"
    else
      method = "Braintree Paid"
    end
    mail(to: check_environment ? DEFAULT_TO : [@payment_email], subject: "#{@course_type} - #{method} - #{@course.name}")
  end

  def no_available_essay(enrolment)
    # @enrolment = enrolment
    # @course = enrolment.course
    # @student = enrolment.user
    # @manager_email = "#{@course.city}.manager@gradready.com.au"
    # mail(to: check_environment ? DEFAULT_TO : [@manager_email], subject: "Insufficient essays - #{@course.name} - #{@course.product_version.name}")
  end

  def send_free_trial_expiry_mail_after_14_days(enrolment)
    @enrolment = enrolment
    @trial_course = enrolment.course
    @student = enrolment.user
    @product_line = @trial_course.product_version.type.underscore.split("_")[0]
    mail(to: check_environment ? DEFAULT_TO : [@student.email], subject: "Financial aid available")
  end

  def free_trial_expiry_mail_today(enrolment)
    # @enrolment = enrolment
    # @trial_course = enrolment.course
    # @student = enrolment.user
    # @product_line = @trial_course.product_version.type.underscore.split("_")[0]
    # mail(to: check_environment ? DEFAULT_TO : [@student.email], subject: "Continue Studying with GradReady")
  end

  def discount_link_auto_email(enrolment)
    @order = enrolment.order
    @student = enrolment.user
    mail(to: check_environment ? DEFAULT_TO : @student.email, subject: "Receive a Discount on Your Purchased Course by Sharing Your Link!")
  end

  def unenrollment_notification(enrolment)
    @course = enrolment.course
    @enrolment = enrolment
    @student = enrolment.user
    mail(to: check_environment ? DEFAULT_TO : @student.email, subject: "You have been unenrolled from a course") if @student.present?
  end

  def enrolment_order_received(student)
    @student = student
    mail(to: check_environment ? DEFAULT_TO : @student.email, subject: "Enrolment Order Received - Bank Transfer")
  end

  private
    def generate_pdf_content(enrolment)
      pdf = InvoicePdf.new(enrolment)
      pdf.render
    end

end
