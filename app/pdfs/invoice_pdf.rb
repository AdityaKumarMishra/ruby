# Code modified from https://www.sitepoint.com/pdf-generation-rails/ <- use for guide how to use
require "prawn/table"

class InvoicePdf < Prawn::Document
  def initialize(order)
    # Set margin to page (top, right, bottom, left) is 60 points
    super(:margin => [60])
    @order = order
    @student = @order.user
    @reference_number = @order.reference_number
    header
    student_details
    payment_details
    invoice_details
    total_details
    regards_message
  end

  def header
    text "Tax Invoice", size: 30, style: :bold, :align => :center, color: "d6e8da"
  end

  def student_details
    move_down 40
    text "Date: #{@order.created_at.strftime("%d/%m/%Y")} ", :size => 10, :align => :right, color: "858a84"
    move_down 20
    text "#{@student.first_name.try(:titleize)}", :size => 10, :align => :right, color: "858a84"
    move_down 20
    if @student.address.present?
      if @student.address.line_one.present?
        text "#{@student.address.line_one.titleize}", :size => 10, :align => :right, color: "858a84"
        move_down 5
      end
      if @student.address.city.present?
        text "#{@student.address.city.titleize}", :size => 10, :align => :right, color: "858a84"
        move_down 5
      end
      if @student.address.state.present?
        text "#{@student.address.state.titleize} #{@student.address.post_code}", :size => 10, :align => :right, color: "858a84"
        move_down 20
      end
    end
    text "Customer ID: #{@student.email}", :size => 10, :align => :right, color: "858a84"
  end

  def payment_details
    move_down 40
    table payment_item_rows, :width => 500 do
      row(0).style(:background_color => 'ebf2ea', :text_color => "858a84")
      columns(0..1).border_color = 'abb7ab'
      self.header = true
      self.column_widths = {0 => 250, 1 => 250}
    end
  end

  def payment_item_rows
    [["Payment Method", "Invoice Number"]] +
    [[ "#{@order.purchase_method.try(:titleize)} ", "#{@order.reference_number}"]]
  end

  def invoice_details
    move_down 40
    table invoice_item_rows, :width => 500 do
      row(0).style(:background_color => 'ebf2ea', :text_color => "858a84")
      columns(0..5).border_color = 'abb7ab'
      self.header = true
      self.column_widths = {0 => 27, 1 => 193, 2 => 70, 3 => 70, 4 => 70, 5 => 70}
    end
  end

  def invoice_item_rows
    count = 0
    table_row = [["No.", "Course / Feature Name", "Cost (GST Exclusive)", "GST", "Discounts / Name", "Shipping Cost"]]
    table_col1 = @order.purchase_items.map do |pi|
                  count = count + 1
                  [ "#{count}", "#{format_sentence(pi.purchase_description)}", "#{format_number(pi.initial_cost)}", "#{format_number(pi.added_gst)}", "#{format_number(pi.discount_applied)}#{pi.discount_name.present? ? '/ ' + pi.discount_name : ''}", "#{format_number(pi.shipping_cost)}" ]
                end

    table_col2 = @order.purchase_items.includes(enrolment: [course: :product_version]).where(product_versions: {course_type: 1}).map do |cus_pi|
        table_col1 += cus_pi.enrolment.feature_logs.where(description: 'custom purchase').map  do |fl|
          count = count + 1
          without_gst_price = fl.product_version_feature_price.ten_percent_gst_amount - fl.product_version_feature_price.price
          without_gst_price = format_number(without_gst_price)
          shipping_cost = if fl.product_version_feature_price.master_feature.hardcopy?
                            format_number(@student.textbook_shipping_cost.to_f)
                          else
                            format_number(0.0)
                          end
          [ "",
            fl.master_feature.custom_feature_name(fl.product_version_feature_price.qty, fl.course.product_version.try(:type)),
            format_number(fl.product_version_feature_price.price),
            without_gst_price,
            format_number(0.0),
            shipping_cost
          ]
        end
    end
    table_row + table_col1
  end

  def features_detail(pi)
    if features_details_row(pi).present?
      make_table features_details_row(pi), :width => 171 do
        self.header = true
        columns(0).border_width = 0
        self.column_widths = {0 => 171}
      end
    end
  end

  def features_details_row(pi)
    user = pi.user
    course= pi.purchasable.course
    user.active_course = course
    features = user.accessible_features

    features.map do |f|
      [ "• #{f.name}"]
    end
  end

  def total_details
    move_down 60
    start_new_page if cursor <= 220.0

    table total_item_rows, :width => 500 do
      columns(3).border_color = 'abb7ab'
      columns(0..2).border_width = 0
      columns(2).style(:align => :right, :text_color => "858a84")
      self.header = true
      self.column_widths = {0 => 54, 1 => 180, 2 => 171, 3 => 95}
    end
  end

  def total_item_rows
    row_values = total_item_values
    max_str_length = row_values.map(&:length).max

    [ ["","", "Cost (GST Exclusive)", "$ #{display_total_value(row_values[0], max_str_length)}"],
    ["","", "GST", "$ #{display_total_value(row_values[1], max_str_length)}"],
    ["","", "Discount", "$ #{display_total_value(row_values[2], max_str_length)}"],
    ["","", "Sub Total", "$ #{display_total_value(row_values[3], max_str_length)}"],
    ["","", "Shipping Cost", "$ #{display_total_value(row_values[4], max_str_length)}"],
    ["","", "Payment Fees", "$ #{display_total_value(row_values[5], max_str_length)}"],
    ["","", "Total Cost", "$ #{display_total_value(row_values[6], max_str_length)}"]
  ]
  end

  def regards_message
    number_pages "GradReady Pty. Ltd. ABN: 21 152 121 456  support@gradready.com.au", :start_count_at => 0, :page_filter => :all, :at => [bounds.left - 0, 0], :align => :center, color: "abb7ab"
  end

  private

  def total_item_values
    [
      format_number(@order.total_initial_cost),
      format_number(@order.total_added_gst),
      format_number(@order.total_discount),
      format_number(@order.order_subtotal),
      format_number(@order.total_shipping_cost),
      format_number(@order.total_method_fee),
      format_number(@order.total_cost)
    ]
  end

  def display_total_value(current_total_value, max_total_length)
    difference = max_total_length - current_total_value.length

    "#{(' ' * difference * 2)}#{current_total_value}"
  end

  def format_number(num)
    ActionController::Base.helpers.number_to_currency(num.round(2))[1..-1]
  end

  def format_sentence(sen)
    sen.split(' ').map { |word| word == 'trail' ? 'Trial' : word }.join(' ')
  end
end
