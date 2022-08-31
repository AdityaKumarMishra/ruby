class OrdersMailer < ApplicationMailer
  require 'open-uri'
  default from: "GradReady <student.care@gradready.com.au>"

  def student_new_banktrans(order)
    # if order.user.nil?
    #   mail(to: check_environment ? DEFAULT_TO : "board@gradready.com.au", subject: "Error sending student log: see server logs")
    # else
    #   @order = order
    #   @reference_number = order.reference_number
    #   @amount = order.total_cost
    #   @purchase_items = order.purchase_items
    #   @student = order.user
    #   mail(to: check_environment ? DEFAULT_TO : @student.email, subject: "Direct Debit Payment Required for #{@student.username} for new purchase")
    # end
  end

  def staff_new_banktrans(order)
    @board = "board@gradready.com.au"
    @logistics = "logistics.manager1@gradready.com.au"
    @payments = "payment@gradready.com.au"
    @reference_number = order.reference_number
    @order = order
    @course = @order.student_course
    @other_orders = @order.other_orders
    course =@order.student_course
    @course_type = course.course_type

    @course_name =  course.name
    @product_version_name = course.product_version.name
    @purchased_course_type= ProductVersion.course_types[course.product_version.course_type]

    if order.user.nil?
      mail(to: @board, subject: "Error enrolling: see server logs")
      @student_name = "N/A"
      @student_email = "N/A"
    else
      @student = order.user
      @purchase_items = order.purchase_items

      if @student.nil?
        mail(to: @board, subject: "Error enrolling with student: see server logs")
      else
        @student_name = @student.full_name
        @student_email = @student.email

        if order.free?
          mail(to: [@payments], subject: "#{@course_type} - Free Trial - #{@course_name}")
        elsif @purchased_course_type == 10
          mail(to: [@payments], subject: "#{@course_type} - Free Study Guide - #{@course_name.gsub("Free ", "")}")
        else
          mail(to: [@payments], subject: "#{@course_type} - DD unpaid - #{@course_name}")
        end

      end
    end
  end

  def student_tax_invoice(order)
    @order = order
    @reference_number = @order.reference_number
    @student = @order.user
    @feature_log = @order.purchase_items.first.purchasable_type == "FeatureLog" if @order.purchase_items.present?

    if @order.purchase_items.count == 1
      if @feature_log
        @title = @order.purchase_items.first.purchase_description
      else
        @title = @order.purchase_items.first.purchasable.course.name
      end
    else
      @title = @order.purchase_items.map{|i| i.purchasable.product_version_feature_price.master_feature.name if i.purchasable_type == 'FeatureLog' }.compact
      @title = @title.join(', ')
    end
    attachments['Invoice.pdf'] = generate_pdf_content(@order)
    mail(to: check_environment ? DEFAULT_TO : @student.email, subject: "Tax Invoice for Purchase of #{@title}")
  end

  def student_complete_purchase(order)
    # @board = "board@gradready.com.au"
    # @payments = "payment@gradready.com.au"
    # if order.user.nil?
    #   mail(to: [@board, @payments], subject: "Error sending student log: see server logs")
    # else
    #   @order = order
    #   @reference_number = order.reference_number
    #   @amount = order.total_cost
    #   @purchase_items = order.purchase_items
    #   @student = order.user
    #   mail(to: check_environment ? DEFAULT_TO : @student.email, subject: "Successful purchase for #{@student.username}")
    # end
  end

  def trial_course_congratulation(order)
    @student = order.user
    mail(to: check_environment ? DEFAULT_TO : check_environment ? DEFAULT_TO : @student.email, subject: "Congratulations of Enrolling in GradReady’s GAMSAT Free Trial!")
  end

  def staff_complete_purchase(order)
    @board = "board@gradready.com.au"
    @payments = "payment@gradready.com.au"
    @order = order
    course =@order.student_course
    @course_type = course.course_type
    @course_name =  course.name
    @product_version_name = course.product_version.name
    @other_orders = @order.other_orders
    @braintree_number = @order.brain_tree_reference

    if @order.direct_deposit?
      method = "DD Paid"
    else
      method = "Braintree Paid"
    end

    if order.user.nil?
      mail(to: "board@gradready.com.au", subject: "Error sending student log: see server logs")
    else
      @reference_number = order.reference_number
      @amount = order.total_cost
      @purchase_items = order.purchase_items
      @student = order.user
      mail(to: [@payments], subject: "#{@course_type} - #{method} - #{course.name}")
    end
  end

  def specific_addon_purchase(order)
    # mail(to: check_environment ? DEFAULT_TO : order.user.email, subject: "GradReady Online Interactive Tutorials - Enrolment & Session Timetable")
  end

  def promo_applied(promo)
    @promo = promo

    mail(to: check_environment ? DEFAULT_TO : "accounts@gradready.com.au", subject: "Promotional code used - Please refund #{@promo.user}")
  end

  def promo_shared(to, order)
    @order = order
    @user_name = @order.user.full_name
    mail(to: check_environment ? DEFAULT_TO : to, subject: " #{@order.user.full_name} has gifted you 10% off your purchase at GradReady")
  end

  def unsuccessful_purchase(order)
    @reference_number = order.reference_number
    @amount = order.total_cost
    @student = order.user
    mail(to: check_environment ? DEFAULT_TO : "payment@gradready.com.au", subject: "Unsuccessful purchase for #{@student.username}")
  end

  def customise_master_feature_mail(order, email_template)
    @email_template = email_template
    @student = order.user
    if @email_template.attachment_name_file_name.present?
      attachments[@email_template.attachment_name_file_name]  = {
        mime_type: 'application/pdf',
        content: URI.open(URI.parse(@email_template.attachment_name.url)).read
      }
      # unless File.exist?("#{Rails.root}/public/attachment_#{@email_template.id}.pdf")
      #   file = open(@email_template.attachment_name.url)
      #   IO.copy_stream(file, "#{Rails.root}/public/attachment_#{@email_template.id}.pdf")
      # end
      # attachments[@email_template.attachment_name_file_name] = File.read("#{Rails.root}/public/attachment_#{@email_template.id}.pdf")
    end
    mail(to: check_environment ? DEFAULT_TO : @student.email, subject: "#{@email_template.email_subject}")
  end

  private
    def generate_pdf_content(enrolment)
      pdf = InvoicePdf.new(enrolment)
      pdf.render
    end
end
