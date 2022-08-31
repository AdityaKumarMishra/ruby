class TextbookUrlController < ApplicationController
  before_action :authenticate_user!, only: [:download]

  include ActionController::Live
  #extend ActiveSupport::Concern uncommnet this as rails 5 upgrade if ActionController do not work

  def download

    tb = TextbookUrl.find_by(id: params[:id])
    #If they're the wrong user for this URL, 404
    if tb.present?
      if current_user != tb.user or tb.nil? or tb.textbook.nil?
        raise ActionController::RoutingError.new('Not Found')
      else

        #Download the textbook from the S3 and stream it to the user
        unless tb.textbook.document.url.include?("missing.png")
          response.headers['Content-Type'] = 'application/pdf'
          uri = URI(tb.textbook.document.url)
          Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
            request = Net::HTTP::Get.new uri
            http.request request do |res|
              res.read_body do |chunk|
                response.stream.write chunk
              end
            end
          end

          response.stream.close
          tb.destroy #Remove the URL from the database since it was unique to this user
        end
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def pt2mm(pt)
    (pt2in(pt) * BigDecimal.new("25.4")).round(2)
  end

  def pt2in(pt)
    (pt / BigDecimal.new("72")).round(2)
  end

  def download_file
    @textbook = Textbook.find(params[:id])
    url = @textbook.document.url
    #url = "http://www.africau.edu/images/default/sample.pdf"
    #url = "#{Rails.root}/public/doc.pdf"
    if params[:type] == "attendance_course_resources" || params[:type] == "attendance_course_slides" || params[:type] == "downloadable_resources"
      url1 = open(url)
      reader = PDF::Reader.new(url1)
      bbox = reader.page(1).attributes[:MediaBox]
      width  = bbox[2] - bbox[0]
      height = bbox[3] - bbox[1]

      width1 = "#{pt2mm(width).to_s("F")}mm"
      height1 = "#{pt2mm(height).to_s("F")}mm"

      if width1 <= "260mm" && height1 <= "210mm"
        logo_pdf = WickedPdf.new.pdf_from_string(render_to_string('/watermarks/indexppt.pdf.html'), background: true, :show_as_html => true)
      elsif width1 >= "300mm" && height1 <= "210mm"
        logo_pdf = WickedPdf.new.pdf_from_string(render_to_string('/watermarks/indexpptlarge.pdf.html'), background: true, :show_as_html => true, page_height: '190mm', page_width: '339mm')  
      else
        logo_pdf = WickedPdf.new.pdf_from_string(render_to_string('/watermarks/index.pdf.html'), background: true, :show_as_html => true)
      end
      File.open(Rails.root.join('public', "logo_pdf.pdf"), 'wb') do |file|
        file << logo_pdf
      end
      company_logo = CombinePDF.load("#{Rails.root}/public/logo_pdf.pdf").pages[0]
      pdf = CombinePDF.parse Net::HTTP.get_response(URI.parse(url)).body
      if height >= 1500 && width >= 1500
        pdf.pages.each {|page| page.resize [0, 0, 600, 842]}
      end
      pdf.pages.each {|page| page << company_logo}
      pdf.save "#{Rails.root}/public/#{@textbook.document_file_name.split('.').first}-#{current_user.try(:id)}.pdf"
      file = "#{Rails.root}/public/#{@textbook.document_file_name.split('.').first}-#{current_user.try(:id)}.pdf"
      File.open(file, 'r') do |f|
       send_data f.read.force_encoding('BINARY'), :filename => @textbook.document_file_name, :type => "application/pdf", stream: 'true', buffer_size: '4096'
      end
      File.delete(file)
    else
      data = open(url)
      send_data data.read, filename: @textbook.document_file_name, type: "application/pdf", stream: 'true', buffer_size: '4096'
    end
  end
end
