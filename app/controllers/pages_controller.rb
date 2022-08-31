class PagesController < ApplicationController
  before_action :set_gamsat_product_info, only: [:main, :gamsat]
  before_action :set_umat_product_info, only: [:main, :umat]
  before_action :set_vce_product_info, only: [:main, :vce]
  before_action :set_hsc_product_info, only: [:main, :hsc]
  before_action :increment_download_hit_counter, only: [:gam_study_schedule , :physics_formula_sheet, :gam_study_syllabus, :gamsat_2019, :what_is_gamsat,
                                                        :gamsat_scores, :medical_school_entry_requirements, :australian_medical_schools,:pathways_to_medicine,
                                                        :gamsat_preparation, :gamsat_section_1, :gamsat_section_2, :gamsat_section_3, :gamsat_free_resources,
                                                        :gamsat_free_practice, :gamsat_example_essay, :gamsat_biology, :gamsat_chemistry, :gamsat_physics,
                                                        :what_is_ucat, :ucat_preparation, :ucat_structure, :ucat_parents_guide, :ucat_students_guide,
                                                        :ucat_vs_gamsat, :ucat_dentistry, :gamsat_non_science_background]
  before_action :enable_recommender, only: ["main", "gamsat", "umat", "vce", "hsc", "gamsat_scholarship", "gamsat-compare_gradready", "gamsat_about",
                                            "umat_scholarship", "umat-compare_umatready", "umat_about", "vce-scholarship",
                                            "vce-compare", "vce-about", "hsc-scholarship", "hsc-compare", "hsc-about", "team", "privacy","terms",
                                            "faq", "gamsat_our_students", "gamsat_student_testimonials", "gamsat_principal", "umat_principal"]
  include ApplicationHelper
  include ProductVersionsHelper

  layout 'layouts/public_page', only: [:main, :gamsat, :umat, :terms, :privacy, :team, :gamsat_preparation, :gamsat_section_1, :gamsat_section_2, :gamsat_section_3,
                                       "gamsat_scholarship", "gamsat_free_resources", "umat_scholarship", "gamsat_student_testimonials","pathways_to_medicine",
                                       "umat_student_testimonials", "recent_update", "gamsat_about", "umat_about", "gamsat_our_students", "umat_our_students",
                                       "umat_free_resources", "gamsat_access_program", "umat_access_program", "gamsat_principal", "umat_principal", "what_is_gamsat",
                                       "gamsat_2022", "medical_school_entry_requirements", "australian_medical_schools", "gamsat_scores", "gamsat_free_practice",
                                       "gamsat_example_essay", "gamsat_physics_formula_sheet", "gamsat_study_schedule", "gamsat_study_syllabus", "gamsat_partners",
                                       "gamsat_textbooks","gamsat_quote_generator", "gamsat_biology", "gamsat_chemistry", "gamsat_physics", "gamsat_non_science_background",
                                       "what_is_ucat", "ucat_preparation", "ucat_structure", "ucat_parents_guide", "ucat_students_guide", "ucat_vs_gamsat", "ucat_dentistry"]

  def main
    @announcement = get_announcement('Homepage')
    @announcement_url = get_announcement_url('Homepage')
    @user = User.new(role: :student)
    @countdown_timer = CountdownTimer.by_page_type(2);
  end

  def gamsat
    @announcement = get_announcement('GamsatReady')
    @announcement_url = get_announcement_url('GamsatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('GamsatReady')
    end
    @countdown_timer = CountdownTimer.by_page_type(0)
  end

  def gamsat_non_science_background
    @podcast = Podcast.find_by(slug: 'gamsat-exam-prep-from-a-non-science-background')
    @announcement = get_announcement('GamsatReady')
    @announcement_url = get_announcement_url('GamsatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('GamsatReady')
    end
    @countdown_timer = CountdownTimer.by_page_type(0)
  end

  def what_is_ucat
    @announcement = get_announcement('UmatReady')
    @announcement_url = get_announcement_url('UmatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('UmatReady')
    end
  end

  def ucat_vs_gamsat
    @announcement = get_announcement('UmatReady')
    @announcement_url = get_announcement_url('UmatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('UmatReady')
    end
  end

  def ucat_dentistry
    @announcement = get_announcement('UmatReady')
    @announcement_url = get_announcement_url('UmatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('UmatReady')
    end
  end

  def ucat_preparation
    @announcement = get_announcement('UmatReady')
    @announcement_url = get_announcement_url('UmatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('UmatReady')
    end
  end

  def ucat_structure
    @announcement = get_announcement('UmatReady')
    @announcement_url = get_announcement_url('UmatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('UmatReady')
    end
  end

  def ucat_parents_guide
    @announcement = get_announcement('UmatReady')
    @announcement_url = get_announcement_url('UmatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('UmatReady')
    end
  end

  def ucat_students_guide
    @announcement = get_announcement('UmatReady')
    @announcement_url = get_announcement_url('UmatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('UmatReady')
    end
  end

  def umat_scholarship
    @announcement = get_announcement('UmatReady')
    @announcement_url = get_announcement_url('UmatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('UmatReady')
    end
  end

  def umat_principal
    @announcement = get_announcement('UmatReady')
    @announcement_url = get_announcement_url('UmatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('UmatReady')
    end
  end

  def umat_our_students
    @announcement = get_announcement('UmatReady')
    @announcement_url = get_announcement_url('UmatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('UmatReady')
    end
  end

  def umat_student_testimonials
    @announcement = get_announcement('UmatReady')
    @announcement_url = get_announcement_url('UmatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('UmatReady')
    end
  end

  def umat_access_program
    @announcement = get_announcement('UmatReady')
    @announcement_url = get_announcement_url('UmatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('UmatReady')
    end
  end

  def umat_free_resources
    @announcement = get_announcement('UmatReady')
    @announcement_url = get_announcement_url('UmatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('UmatReady')
    end
  end

  def umat_about
    @announcement = get_announcement('UmatReady')
    @announcement_url = get_announcement_url('UmatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('UmatReady')
    end
  end

  def gamsat_student_testimonials
    @announcement = get_announcement('GamsatReady')
    @announcement_url = get_announcement_url('GamsatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('GamsatReady')
    end
  end

  def gamsat_our_students
    @announcement = get_announcement('GamsatReady')
    @announcement_url = get_announcement_url('GamsatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('GamsatReady')
    end
  end

  def gamsat_scholarship
    @announcement = get_announcement('GamsatReady')
    @announcement_url = get_announcement_url('GamsatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('GamsatReady')
    end
  end

  def gamsat_principal
    @announcement = get_announcement('GamsatReady')
    @announcement_url = get_announcement_url('GamsatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('GamsatReady')
    end
  end

  def gamsat_access_program
    @announcement = get_announcement('GamsatReady')
    @announcement_url = get_announcement_url('GamsatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('GamsatReady')
    end
  end

  def what_is_gamsat
    @announcement = get_announcement('GamsatReady')
    @announcement_url = get_announcement_url('GamsatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('GamsatReady')
    end
  end

  def gamsat_scores
    @announcement = get_announcement('GamsatReady')
    @announcement_url = get_announcement_url('GamsatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('GamsatReady')
    end
  end

  def medical_school_entry_requirements
    @announcement = get_announcement('GamsatReady')
    @announcement_url = get_announcement_url('GamsatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('GamsatReady')
    end
  end

  def australian_medical_schools
  end
  def pathways_to_medicine
  end
  def gamsat_preparation
    @announcement = get_announcement('GamsatReady')
    @announcement_url = get_announcement_url('GamsatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('GamsatReady')
    end
  end

  def gamsat_section_1
    @announcement = get_announcement('GamsatReady')
    @announcement_url = get_announcement_url('GamsatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('GamsatReady')
    end
  end

  def gamsat_section_2
    @announcement = get_announcement('GamsatReady')
    @announcement_url = get_announcement_url('GamsatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('GamsatReady')
    end
  end

  def gamsat_section_3
    @announcement = get_announcement('GamsatReady')
    @announcement_url = get_announcement_url('GamsatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('GamsatReady')
    end
  end

  def gamsat_biology
    @announcement = get_announcement('GamsatReady')
    @announcement_url = get_announcement_url('GamsatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('GamsatReady')
    end
  end

  def gamsat_chemistry
    @announcement = get_announcement('GamsatReady')
    @announcement_url = get_announcement_url('GamsatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('GamsatReady')
    end
  end

  def gamsat_physics
    @announcement = get_announcement('GamsatReady')
    @announcement_url = get_announcement_url('GamsatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('GamsatReady')
    end
  end

  def gamsat_free_resources
    @announcement = get_announcement('GamsatReady')
    @announcement_url = get_announcement_url('GamsatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('GamsatReady')
    end

    post_slugs = ["how-hard-is-the-gamsat" , "breaking-down-gamsat-essay-questions", "how-to-revise-for-the-gamsat",
      "5-common-mmi-mistakes-to-avoid", "working-full-time-and-studying-for-gamsat", "gamsat-exam-what-to-do-the-night-before","preparing-for-the-gamsat-with-a-non-science-background"]

    @posts = Post.where(slug: post_slugs)
  end

  def gamsat_textbooks

    @product_version = ProductVersion.friendly.find_by(slug: "custom")
    @cities = Course.where(product_version_id: @product_version.id).where('enrolment_end_date >= ?', Time.zone.now.beginning_of_day).collect(&:city).uniq.compact.sort
    @cities = @cities - ["Other"]
    @first_city = @cities.first
    @courses = Course.where(product_version_id: @product_version.id, city: Course.cities[@first_city]).where('enrolment_end_date >= ?', Time.zone.now.beginning_of_day).order(:enrolment_end_date).select{|p| !p.course_full?}
    @selected_course = @courses.first
    @pvfps = @product_version.product_version_feature_prices.where(is_default: false, is_additional: false)
    @hard_copy_feature = @pvfps.where(master_feature_id: 26).first
    @online_feature = @pvfps.where(master_feature_id: 41).first
    @outofstock = OutOfStock.first
    @announcement = get_announcement('GamsatReady')
    @announcement_url = get_announcement_url('GamsatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('GamsatReady')
    end
  end

  def gamsat_study_schedule
    @announcement = get_announcement('GamsatReady')
    @announcement_url = get_announcement_url('GamsatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('GamsatReady')
    end
  end

  def gamsat_physics_formula_sheet
    @announcement = get_announcement('GamsatReady')
    @announcement_url = get_announcement_url('GamsatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('GamsatReady')
    end
  end

  def gamsat_free_practice
    @announcement = get_announcement('GamsatReady')
    @announcement_url = get_announcement_url('GamsatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('GamsatReady')
    end
  end

  def gamsat_example_essay
    @announcement = get_announcement('GamsatReady')
    @announcement_url = get_announcement_url('GamsatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('GamsatReady')
    end
  end

  def gamsat_study_syllabus
    @announcement = get_announcement('GamsatReady')
    @announcement_url = get_announcement_url('GamsatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('GamsatReady')
    end
  end

  def recent_update
    if params["tab"] == "UMAT"
      @announcement = get_announcement('UmatReady')
      @announcement_url = get_announcement_url('UmatReady')
      if !@announcement_url.nil?
        @announcement_url = get_announcement_url('UmatReady')
      end
    elsif params["tab"] == "GAMSAT"
      @announcement = get_announcement('GamsatReady')
      @announcement_url = get_announcement_url('GamsatReady')
      if !@announcement_url.nil?
        @announcement_url = get_announcement_url('GamsatReady')
      end
    end
  end

  def gamsat_about
    @announcement = get_announcement('GamsatReady')
    @announcement_url = get_announcement_url('GamsatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('GamsatReady')
    end
  end

  def gamsat_2022
    @announcement = get_announcement('GamsatReady')
    @announcement_url = get_announcement_url('GamsatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('GamsatReady')
    end
  end

  def gamsat_partners
    @announcement = get_announcement('GamsatReady')
    @announcement_url = get_announcement_url('GamsatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('GamsatReady')
    end
  end

  def umat
    @announcement = get_announcement('UmatReady')
    @announcement_url = get_announcement_url('UmatReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('UmatReady')
    end
    @countdown_timer = CountdownTimer.by_page_type(1)
  end

  def vce
    @announcement = get_announcement('VceReady')
    @announcement_url = get_announcement_url('VceReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('VceReady')
    end
  end

  def hsc
    @announcement = get_announcement('HscReady')
    @announcement_url = get_announcement_url('HscReady')
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url('HscReady')
    end
  end

  def team
    @product_line = map_url_to_product_line(request.env['PATH_INFO'])
    if @product_line == "umat"
      @announcement = get_announcement('UmatReady')
      @announcement_url = get_announcement_url('UmatReady')
      if !@announcement_url.nil?
        @announcement_url = get_announcement_url('UmatReady')
      end
    elsif @product_line == "gamsat"
      @announcement = get_announcement('GamsatReady')
      @announcement_url = get_announcement_url('GamsatReady')
      if !@announcement_url.nil?
        @announcement_url = get_announcement_url('GamsatReady')
      end
    end
    render "pages/#{@product_line}_team.html.haml"
  end

  def privacy
    @product_line = map_url_to_product_line(request.env['PATH_INFO']).upcase
  end

  def terms
    @product_line = map_url_to_product_line(request.env['PATH_INFO']).upcase
  end

  def google_verify_page
    render layout: false
  end

  def show_course_recommender
    respond_to do |format|
      format.js
    end
  end

  def set_footer
    @type = params[:type]
  end

  def download_gamsat_pdf
    pdf = GamsatComparisonCoursePdf.new
    send_data pdf.render, filename: "Gamsat_Course_Comparion_Guide.pdf", type: 'application/pdf'
  end

  def download_umat_pdf
    pdf = UmatComparisonCoursePdf.new
    send_data pdf.render, filename: "Umat_Course_Comparion_Guide.pdf", type: 'application/pdf'
  end

  def gam_study_schedule
    data = open("https://gradready.s3.ap-southeast-2.amazonaws.com/static/public_pages/gam_study_schedule.pdf") 
    send_data data.read, filename: "gam_study_schedule.pdf", type: "application/pdf", disposition: 'inline', stream: 'true', buffer_size: '4096'
  end

  def physics_formula_sheet
    data = open("https://gradready.s3.ap-southeast-2.amazonaws.com/static/public_pages/Section_3_GAMSAT_Physics_Formula_Sheet.pdf") 
    send_data data.read, filename: "Section_3_GAMSAT_Physics_Formula_Sheet.pdf", type: "application/pdf", disposition: 'inline', stream: 'true', buffer_size: '4096'

  end

  def gam_study_syllabus
    data = open("https://gradready.s3.ap-southeast-2.amazonaws.com/static/public_pages/GradReady_GAMSAT_Study_Syllabus.pdf") 
    send_data data.read, filename: "GradReady_GAMSAT_Study_Syllabus.pdf", type: "application/pdf", disposition: 'inline', stream: 'true', buffer_size: '4096'
  end

  def essay_writing_guide
    data = open("https://gradready.s3.ap-southeast-2.amazonaws.com/static/public_pages/GradReady_GAMSAT_Essay_Writing_Guide.pdf") 
    send_data data.read, filename: "GradReady_GAMSAT_Essay_Writing_Guide.pdf", type: "application/pdf", disposition: 'inline', stream: 'true', buffer_size: '4096'
  end

  def gamsat_quote_generator
    @announcement = get_announcement('GamsatReady')
    @announcement_url = get_announcement_url('GamsatReady')
      if !@announcement_url.nil?
      @announcement_url = get_announcement_url('GamsatReady')
      end
  end

  private

    def increment_download_hit_counter
      file_name = params[:action]
      download_hit_counter = DownloadHitCounter.by_file file_name
      download_hit_counter.increment!(:download_count, 1) unless download_hit_counter.nil?
    end

    def set_gamsat_product_info
      @gamsat_product_info = gamsat_product_info
    end

    def set_umat_product_info
      @umat_product_info = umat_product_info
    end

    def set_vce_product_info
      @vce_product_info = vce_product_info
    end

    def set_hsc_product_info
      @hsc_product_info = hsc_product_info
    end

    def enable_recommender
      @show_course_recommender = true
    end
end
