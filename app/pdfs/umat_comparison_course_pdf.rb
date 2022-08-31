Prawn::Font::AFM.hide_m17n_warning = true
class UmatComparisonCoursePdf < Prawn::Document
  require 'open-uri'
  def initialize()
    super(:margin => [30])
    header_one
    attendance_package_details
    header_two
    non_attendance_package_details
    regards_message
  end

  def header_one
    image open("https://gradready.s3.ap-southeast-2.amazonaws.com/static/public_pages/umat_gradready_logo.png"), :height => 30, :width => 150
    text "Attendance Package", size: 21, :align => :center
  end

  def attendance_package_details
    move_down 20
    table attendance_package_rows, :width => 545 do
      self.column_widths = {0 => 210, 1 => 115, 2 => 110, 3 => 110}
      columns(0..3).style(:border_color => "dddddd", :align => :center, size: 10)
      row(0..26).style(:height => 35)
      columns(0).style(:align => :left, padding_top: 10, padding_left: 5)
      columns(1).style(padding_top: 10)
      rows(0..1).style(padding_top: 10)
      row(0).style(:background_color => 'cccccc')
      row(0).columns(0).style(:background_color => 'ffffff', :border_color => "ffffff")
      rows([1, 9, 18, 24, 26]).columns(0).style(:background_color => 'cccccc')
      row(26).columns(1).style(:background_color => 'cccccc')
      row(26).columns(0).style(:background_color => 'ffffff', :border_color => "ffffff")
      row(0).columns(1).style(:text_color => "007ecc")
    end
  end

  def attendance_package_rows
    image_path = "https://gradready.s3.ap-southeast-2.amazonaws.com/static/public_pages/right_tick_umat.png"
    [["", "GRADREADY", "OTHER PROVIDER 1", "OTHER PROVIDER 2"]] +
    [[ "LIVE COMPONENT", "", "", ""]] +
    [[ "Hours of Live Teaching", "50+ hours", "", ""]] +
    [[ "Number of Students per Class", "18 max", "", ""]] +
    [[ "Teaching Style", "Interactivity Focused", "", ""]] +
    [[ "Specialist Tutor in Each Subject", {:image => image_path, :scale => 0.5, :position => :center}, "", ""]] +
    [[ "Mock Exam Day", {:image => image_path, :scale => 0.5, :position => :center}, "", ""]] +
    [[ "Dedicated Review Day", {:image => image_path, :scale => 0.5, :position => :center}, "", ""]] +
    [[ "Mock Exam Percentile Reported", {:image => image_path, :scale => 0.5, :position => :center}, "", ""]] +
    [[ "PRACTICE MATERIAL", "", "", ""]] +
    [[ "Diagnostics Test", {:image => image_path, :scale => 0.5, :position => :center}, "", ""]] +
    [[ "Auto Reporting System for Diagnostics", {:image => image_path, :scale => 0.5, :position => :center}, "", ""]] +
    [[ "Number of MCQs Available", "1200 and growing weekly", "", ""]] +
    [[ "Performance Tracking System", {:image => image_path, :scale => 0.5, :position => :center}, "", ""]] +
    [[ "Customisable MCQs", {:image => image_path, :scale => 0.5, :position => :center}, "", ""]] +
    [[ "Practice Exams", {:image => image_path, :scale => 0.5, :position => :center}, "", ""]] +
    [[ "Sophisticated Auto Reporting System for Practice Exams", {:image => image_path, :scale => 0.5, :position => :center}, "", ""]] +
    [[ "Exam Percentile Reported", {:image => image_path, :scale => 0.5, :position => :center}, "", ""]] +
    [[ "LEARNING TOOLS", "", "", ""]] +
    [[ "Textbook", {:image => image_path, :scale => 0.5, :position => :center}, "", ""]] +
    [[ "Interactive Online Textbook", {:image => image_path, :scale => 0.5, :position => :center}, "", ""]] +
    [[ "Videos", {:image => image_path, :scale => 0.5, :position => :center}, "", ""]] +
    [[ "Advanced Quality Assurance System", {:image => image_path, :scale => 0.5, :position => :center}, "", ""]] +
    [[ "Cross Referencing System", {:image => image_path, :scale => 0.5, :position => :center}, "", ""]] +
    [[ "1 ON 1 TUTOR ASSISTANCE", "", "", ""]] +
    [[ "Able to Ask Tutor About Specific Material at Click of Button", {:image => image_path, :scale => 0.5, :position => :center}, "", ""]] +
    [[ "", "$ 586", "", ""]]
  end

  def header_two
    move_down 400
    text "Non-Attendance Package", size: 21, :align => :center
  end

  def non_attendance_package_details
    move_down 20
    table non_attendance_package_rows, :width => 545 do
      self.column_widths = {0 => 210, 1 => 115, 2 => 110, 3 => 110}
      row(0..16).style(:height => 35)
      columns(0..3).style(:border_color => "dddddd", :align => :center, size: 10)
      columns(0).style(:align => :left, padding_top: 10, padding_left: 5)
      columns(1).style(padding_top: 10)
      row(0).style(:background_color => 'cccccc')
      rows(0..1).style(padding_top: 10)
      row(0).columns(0).style(:background_color => 'ffffff', :border_color => "ffffff")
      row([1,10]).columns(0).style(:background_color => 'cccccc')
      row(16).columns(1..3).style(:background_color => 'cccccc')
      row(16).columns(0).style(:background_color => 'ffffff', :border_color => "ffffff")
      row(0).columns(1).style(:text_color => "007ecc")
    end
  end

  def non_attendance_package_rows
    image_path = "https://gradready.s3.ap-southeast-2.amazonaws.com/static/public_pages/right_tick_umat.png"
    [["", "GRADREADY", "OTHER PROVIDER 1", "OTHER PROVIDER 2"]] +
    [[ "PRACTICE MATERIAL", "", "", ""]] +
    [[ "Diagnostics Exam", {:image => image_path, :scale => 0.5, :position => :center}, "", ""]] +
    [[ "Auto Reporting System for Diagnostics", {:image => image_path, :scale => 0.5, :position => :center}, "", ""]] +
    [[ "Number of MCQs Available", "1200 and growing weekly", "", ""]] +
    [[ "Performance Tracking System", {:image => image_path, :scale => 0.5, :position => :center}, "", ""]] +
    [[ "Customisable MCQst", {:image => image_path, :scale => 0.5, :position => :center}, "", ""]] +
    [[ "Practice Exams", {:image => image_path, :scale => 0.5, :position => :center}, "", ""]] +
    [[ "Sophisticated Auto Reporting System for Practice Exams", {:image => image_path, :scale => 0.5, :position => :center}, "", ""]] +
    [[ "Exam Percentile Reported", {:image => image_path, :scale => 0.5, :position => :center}, "", ""]] +
    [[ "LEARNING TOOLS", "", "", ""]] +
    [[ "Textbook", {:image => image_path, :scale => 0.5, :position => :center}, "", ""]] +
    [[ "Interactive Online Textbook", {:image => image_path, :scale => 0.5, :position => :center}, "", ""]] +
    [[ "Videos", {:image => image_path, :scale => 0.5, :position => :center}, "", ""]] +
    [[ "Advanced Quality Assurance System", {:image => image_path, :scale => 0.5, :position => :center}, "", ""]] +
    [[ "Cross Referencing System", {:image => image_path, :scale => 0.5, :position => :center}, "", ""]] +
    [[ "", "$ 388", "", ""]]
  end

  def regards_message
    number_pages "Web:", :start_count_at => 0, :page_filter => :all, :at => [bounds.left - -95, 0], color: "808080", size: 10, :style => :bold
    number_pages "https://gradready.com.au |", :start_count_at => 0, :page_filter => :all, :at => [bounds.left - -122, 0], color: "808080", size: 10
    number_pages "Email:", :start_count_at => 0, :page_filter => :all, :at => [bounds.left - -240, 0], color: "808080", size: 10, :style => :bold
    number_pages "student.services@gradready.com.au", :start_count_at => 0, :page_filter => :all, :at => [bounds.left - -272, 0], color: "808080", size: 10
  end

end
