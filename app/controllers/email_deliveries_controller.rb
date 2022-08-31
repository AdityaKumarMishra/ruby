class EmailDeliveriesController < ApplicationController
  require "html2doc"
  require 'spreadsheet'
  before_action :authenticate_user!, except: [:download_email_text]
  layout 'layouts/dashboard'

	def get_all_deliveries
    #@email_deliveries = EmailDelivery.all.order('created_at DESC')
    # params[:filterrific] ||= {}

    # params[:filterrific][:with_start] ||= Date.today
    # params[:filterrific][:with_end] ||= Date.today
    # @filterrific = initialize_filterrific(
    #     EmailDelivery,
    #     params[:filterrific],
    #     select_options: {
    #       by_to: EmailDelivery.all.map{|e| [e.recipient, e.id]},
    #       by_from: EmailDelivery.all.map{|e| [e.from, e.id]}
    #     }
    # ) || return
    # @total_responses = @filterrific.find.order(created_at: :desc)
    # @email_deliveries = @total_responses.paginate(page: params[:page], per_page: 200)
    @email_deliveries = EmailDelivery.all.order("category").group_by(&:category)
  end

  def download_email
    email_deliveries = EmailDelivery.all.order("category")
    if email_deliveries.present?
      grouped_email_deliveries = email_deliveries.group_by(&:category)
      spreadsheet = Spreadsheet::Workbook.new
      sheet = spreadsheet.create_worksheet
      sheet.name = 'Autoemail list'
      format_header = Spreadsheet::Format.new({ :weight => :bold, :pattern => 1, :pattern_fg_color => :silver, :size => 10, :text_wrap => true })
      format_category = Spreadsheet::Format.new({ :weight => :bold, :pattern => 1, :pattern_fg_color => :yellow, :size => 10, :text_wrap => true })
      grouped_email_deliveries.each do |category, emails|
        category = (category == 'na' ? 'NA' : category.titleize) || 'NA'
        if sheet.last_row_index == 0
          sheet.row(0).push category
        else
          sheet.insert_row(sheet.last_row_index + 1)
          sheet.insert_row(sheet.last_row_index + 1, [category])
        end
        sheet.last_row.default_format = format_category
        sheet.insert_row(sheet.last_row_index + 1, ['Email Subject', 'Recipient', 'Trigger/Regular Time As Applicable', 'Autoemail Content PDF', 'Autoemail Content Word'])
        sheet.last_row.default_format = format_header
        emails.each do |email|
          sheet.insert_row(sheet.last_row_index + 1, [email.subject, email.recipient, email.trigger_name])
          sheet[sheet.last_row_index, 3] = Spreadsheet::Link.new "https://#{ENV["MAILER_HOST"]}/email_deliveries/download_email_text.pdf?id=#{email.id}", 'Download PDF'
          sheet[sheet.last_row_index, 4] = Spreadsheet::Link.new "https://#{ENV["MAILER_HOST"]}/email_deliveries/download_email_text.docx?id=#{email.id}", 'Download Word'
        end
      end
      (0..4).to_a.each do |index|
        sheet.column(index).width = 25
      end
      file_path = "#{Rails.root}/public/mails/list_mail.xls"
      spreadsheet.write file_path
      File.open(file_path, 'r') do |f|
        send_data f.read, filename: "EmailDelivery - #{Date.today}.xls"
      end
      File.delete(file_path)
    else
      flash[:error] = 'No email is present'
      redirect_to get_all_deliveries_email_deliveries_path
    end
  end

  def download_email_text
    @email_delivery = EmailDelivery.find_by(id: params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        pdf = render_to_string :pdf => "auto_email", :layout => false, :template => 'email_deliveries/download_email_text.haml'
          send_data(pdf,
                    :filename =>  "auto_email.pdf",
                    :disposition => 'attachment',
                    :type => "application/pdf")
      end
      format.docx do
        #body = @email_delivery.body.gsub("style", "data-style")
        Html2Doc.process(@email_delivery.body.gsub('<!DOCTYPE html>', ''), filename: "#{Rails.root}/public/mails/#{params[:id]}_mail", dir: "#{Rails.root}/public/mails")
        file_path = "#{Rails.root}/public/mails/#{params[:id]}_mail.doc"
        File.open(file_path, 'r') do |f|
          send_data f.read, filename: "#{@email_delivery.subject}.doc"
        end
         # send_data(
         #    "#{Rails.root}/public/mails/#{params[:id]}_mail.doc",
         #    filename: "#{@email_delivery.subject}.doc"
         #  )
        File.delete(file_path)
      end
    end
  end

end
