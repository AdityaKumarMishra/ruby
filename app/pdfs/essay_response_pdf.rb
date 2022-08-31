# Code modified from https://www.sitepoint.com/pdf-generation-rails/ <- use for guide how to use
require 'open-uri'
Prawn::Font::AFM.hide_m17n_warning = true
class EssayResponsePdf < Prawn::Document
  def initialize(essay_response)
    # Set margin to page (top, right, bottom, left) is 60 points
    super(:margin => [60])
    @essay_response = essay_response
    header
    align_text
    title
    align_text
    student_details
    align_text
    text_content
  end

  def header
    #This inserts an image in the pdf file and sets the size of the image
    image open("https://gradready.s3.ap-southeast-2.amazonaws.com/static/grad-green-logo.png"), width: 510, height: 120
  end

  def title
    text "Student Response To Essay", size: 30, style: :bold
  end
  def text_content
    text "Essay Title", size: 15, style: :bold
    text ActionView::Base.full_sanitizer.sanitize  @essay_response.essay.title
    move_down 15
    text "Essay Question", size: 15, style: :bold
    text ActionView::Base.full_sanitizer.sanitize  @essay_response.essay.question


    text "Essay Response", size: 15, style: :bold
    begin
      text ActionView::Base.full_sanitizer.sanitize  @essay_response.response
    rescue Prawn::Errors::IncompatibleStringEncoding
      text ActionView::Base.full_sanitizer.sanitize  @essay_response.response.encode("UTF-8", "Windows-1252", undef: :replace, replace: '')
    end

    if @essay_response.essay_tutor_response.present?
      move_down 15
      text "Tutor Mark", size: 15, style: :bold
      text @essay_response.essay_tutor_response.rating.to_s
      move_down 15
      text "Tutor Response", size: 15, style: :bold

      begin
        text ActionView::Base.full_sanitizer.sanitize  @essay_response.essay_tutor_response.response
      rescue Prawn::Errors::IncompatibleStringEncoding
         text ActionView::Base.full_sanitizer.sanitize  @essay_response.essay_tutor_response.response.encode("UTF-8", "Windows-1252", undef: :replace, replace: '')
      end      
    end
  end

  def student_details

    text "Student Name", size: 15, style: :bold
    text @essay_response.user.full_name
    move_down 15

    if @essay_response.time_submited.present?
      text "Date submitted", size: 15, style: :bold
      text @essay_response.time_submited.in_time_zone("Australia/Melbourne").strftime('%a, %d %b %Y %H:%M').to_s
    end

    if @essay_response.essay_tutor_response.present?
      move_down 15
      text "Tutor Name", size: 15, style: :bold
      text @essay_response.essay_tutor_response.staff_profile.staff.full_name
    end
  end

  def align_text
    move_down 40
  end

end
