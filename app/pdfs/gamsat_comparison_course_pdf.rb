Prawn::Font::AFM.hide_m17n_warning = true
class GamsatComparisonCoursePdf < Prawn::Document
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
    image open("https://gradready.s3.ap-southeast-2.amazonaws.com/static/gradready-logo-green.png"), :height => 30, :width => 150
    text "ATTENDANCE PACKAGE", size: 21, :align => :center
  end

  def attendance_package_details
    move_down 20
    table attendance_package_rows, :width => 545 do
      self.column_widths = {0 => 215, 1 => 165, 2 => 165}
      columns(0..2).style(:border_color => "dddddd", :align => :center, size: 10)
      row(0..33).style(:height => 35)
      columns(0).style(:align => :left, padding_top: 10, padding_left: 5)
      columns(1).style(padding_top: 10)
      rows(0..1).style(padding_top: 10)
      row(0).style(:background_color => 'cccccc')
      row(0).columns(0).style(:background_color => 'ffffff', :border_color => "ffffff")
      rows([1, 16, 25, 31]).columns(0).style(:background_color => 'cccccc')
      # row(34).columns(1).style(:background_color => 'cccccc')
      row(33).columns(0).style(:background_color => 'ffffff', :border_color => "ffffff")
      row(0).columns(1).style(:text_color => "008438")
      row(4).style(:height => 60)
      row(4).columns(0).style(padding_top: 25)
    end
  end

  def attendance_package_rows
    image_path = open("https://gradready.s3.ap-southeast-2.amazonaws.com/static/public_pages/right_tick.png")
    [["", "GRADREADY", "OTHER PROVIDERS"]] +
    [[ "LIVE COMPONENT", "", ""]] +
    [[ "Statistically Significant Score Improvements", "5 years in a row", ""]] +
    [[ "Instructors Have Sat the GAMSAT® Exam", {:image => image_path, :scale => 0.5, :position => :center}, ""]] +
    [[ "Refined Proprietary Online System", "Yes, system constantly refined according to data and student feedback", ""]] +
    [[ "Hours of Live Teaching", "100+ hours", ""]] +
    [[ "Number of Students per Class", "21 max", ""]] +
    [[ "Teaching Style", "Interactivity Focused", ""]] +
    [[ "Specialist Tutor in Each Subject", {:image => image_path, :scale => 0.5, :position => :center}, ""]] +
    [[ "Mock Exam Day", {:image => image_path, :scale => 0.5, :position => :center}, ""]] +
    [[ "Mock Exam Review Day", {:image => image_path, :scale => 0.5, :position => :center}, ""]] +
    [[ "Mock Exam Percentile Reported", {:image => image_path, :scale => 0.5, :position => :center}, ""]] +
    [[ "Option to Access 1 on 1 Teaching", {:image => image_path, :scale => 0.5, :position => :center}, ""]] +
    [[ "Online Interactive Tutorial", {:image => image_path, :scale => 0.5, :position => :center}, ""]] +
    [[ "Intensive Revision Weekend", {:image => image_path, :scale => 0.5, :position => :center}, ""]] +
    [[ "Weekly Q&A Support Sessions", {:image => image_path, :scale => 0.5, :position => :center}, ""]] +
    [[ "PRACTICE MATERIAL", "", ""]] +
    [[ "Diagnostics Test", {:image => image_path, :scale => 0.5, :position => :center}, ""]] +
    [[ "Auto Reporting System for Diagnostics", {:image => image_path, :scale => 0.5, :position => :center}, ""]] +
    [[ "Number of MCQs Available", "4000 and growing weekly", ""]] +
    [[ "Performance Tracking System", {:image => image_path, :scale => 0.5, :position => :center}, ""]] +
    [[ "Customisable MCQs", {:image => image_path, :scale => 0.5, :position => :center}, ""]] +
    [[ "Practice Exams", {:image => image_path, :scale => 0.5, :position => :center}, ""]] +
    [[ "Auto Reporting System for Practice Exams", {:image => image_path, :scale => 0.5, :position => :center}, ""]] +
    [[ "Exam Percentile Reported", {:image => image_path, :scale => 0.5, :position => :center}, ""]] +
    [[ "LEARNING TOOLS", "", ""]] +
    [[ "Textbook", {:image => image_path, :scale => 0.5, :position => :center}, ""]] +
    [[ "Interactive Online Textbook", {:image => image_path, :scale => 0.5, :position => :center}, ""]] +
    [[ "Videos", {:image => image_path, :scale => 0.5, :position => :center}, ""]] +
    [[ "Advanced Quality Assurance System", {:image => image_path, :scale => 0.5, :position => :center}, ""]] +
    [[ "Cross Referencing System", {:image => image_path, :scale => 0.5, :position => :center}, ""]] +
    # [[ "My Performance Profile®", {:image => image_path, :scale => 0.5, :position => :center}, ""]] +
    [[ "1 ON 1 TUTOR ASSISTANCE", "", ""]] +
    [[ "Number of Essays Marked", "10", ""]] +
    [[ "", "$ 1,487", ""]]
  end

  def header_two
    move_down 360
    text "ONLINE PACKAGE", size: 21, :align => :center
  end

  def non_attendance_package_details
    move_down 20
    table non_attendance_package_rows, :width => 545 do
      self.column_widths = {0 => 215, 1 => 165, 2 => 165}
      row(0..22).style(:height => 35)
      columns(0..2).style(:border_color => "dddddd", :align => :center, size: 10)
      columns(0).style(:align => :left, padding_top: 10, padding_left: 5)
      columns(1).style(padding_top: 10)
      row(0).style(:background_color => 'cccccc')
      rows(0..1).style(padding_top: 10)
      row(0).columns(0).style(:background_color => 'ffffff', :border_color => "ffffff")
      row([1,13,19]).columns(0).style(:background_color => 'cccccc')
      # row(23).columns(1..3).style(:background_color => 'cccccc')
      row(22).columns(0).style(:background_color => 'ffffff', :border_color => "ffffff")
      row(0).columns(1).style(:text_color => "008438")
      row(4).style(:height => 60)
      row(4).columns(0).style(padding_top: 25)
    end
  end

  def non_attendance_package_rows
    image_path = open("https://gradready.s3.ap-southeast-2.amazonaws.com/static/public_pages/right_tick.png")
    [["", "GRADREADY", "OTHER PROVIDERS"]] +
    [[ "PRACTICE MATERIAL", "", ""]] +
    [[ "Statistically Significant Score Improvements", "5 years in a row", ""]] +
    [[ "Instructors Have Sat the GAMSAT® Exam", {:image => image_path, :scale => 0.5, :position => :center}, ""]] +
    [[ "Refined Proprietary Online System", "Yes, system constantly refined according to data and student feedback", ""]] +
    [[ "Diagnostics Test", {:image => image_path, :scale => 0.5, :position => :center}, ""]] +
    [[ "Auto Reporting System for Diagnostics", {:image => image_path, :scale => 0.5, :position => :center}, ""]] +
    [[ "Number of MCQs Available", "4000 and growing weekly", ""]] +
    [[ "Performance Tracking System", {:image => image_path, :scale => 0.5, :position => :center}, ""]] +
    [[ "Customisable MCQs", {:image => image_path, :scale => 0.5, :position => :center}, ""]] +
    [[ "Practice Exams", {:image => image_path, :scale => 0.5, :position => :center}, ""]] +
    [[ "Auto Reporting System for Practice Exams", {:image => image_path, :scale => 0.5, :position => :center}, ""]] +
    [[ "Exam Percentile Reported", {:image => image_path, :scale => 0.5, :position => :center}, ""]] +
    [[ "LEARNING TOOLS", "", ""]] +
    [[ "Textbook", {:image => image_path, :scale => 0.5, :position => :center}, ""]] +
    [[ "Interactive Online Textbook", {:image => image_path, :scale => 0.5, :position => :center}, ""]] +
    [[ "Videos", {:image => image_path, :scale => 0.5, :position => :center}, ""]] +
    [[ "Advanced Quality Assurance System", {:image => image_path, :scale => 0.5, :position => :center}, ""]] +
    [[ "Cross Referencing System", {:image => image_path, :scale => 0.5, :position => :center}, ""]] +
    # [[ "My Performance Profile®", {:image => image_path, :scale => 0.5, :position => :center}, ""]] +
    [[ "1 ON 1 TUTOR ASSISTANCE", "", ""]] +
    [[ "Number of Essays Marked", "10", ""]] +
    [[ "Weekly Q&A Support Sessions", {:image => image_path, :scale => 0.5, :position => :center}, ""]] +
    [[ "", "$ 876", ""]]
  end

  def regards_message
    number_pages "Web:", :start_count_at => 0, :page_filter => :all, :at => [bounds.left - -95, 0], color: "808080", size: 10, :style => :bold
    number_pages "https://gradready.com.au |", :start_count_at => 0, :page_filter => :all, :at => [bounds.left - -122, 0], color: "808080", size: 10
    number_pages "Email:", :start_count_at => 0, :page_filter => :all, :at => [bounds.left - -240, 0], color: "808080", size: 10, :style => :bold
    number_pages "student.services@gradready.com.au", :start_count_at => 0, :page_filter => :all, :at => [bounds.left - -272, 0], color: "808080", size: 10
  end

end
