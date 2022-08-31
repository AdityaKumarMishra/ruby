module PagesHelper
  # TODO: Uses a case statement to be able to handle default case instead
  def map_country_code_to_name(identifier)
    country_code_hashes = {
      'VIC' => 'Melbourne',
      'NSW' => 'Sydney',
      'QLD' => 'Brisbane',
      'WA' => 'Perth',
      'SA' => 'Adelaide',
      'ACT' => 'Canberra',
      'NT' => 'Darwin',
      'TAS' => 'Tasmania'
    }
    return country_code_hashes[identifier]
  end
  # TODO: Avoid overcrowding ruby helper (not the best practice)
  # by having ONE central product_version_uri
  def dynamic_gamsat_product_version_uri (name, feature_name="")
    product_version_hashes = {
      'online-basic' => 'online-essentials',
      'online' => 'online-comprehensive',
      'attendence-basic' => 'attendance-essentials',
      'attendence' => 'attendance-comprehensive',
      'attendence-all' => 'attendance-complete-care',
      'interviewready-attendance-comprehensive' => 'interview-attendance-comprehensive',
      'interviewready-attendance-essentials' => 'interview-attendance-essentials',
      'interviewready-online-essentials' => 'interview-online-essentials',
      'custom' => 'custom',
      '1-week-trial' => 'free-trial'
    }
    if feature_name.present?
      feature_name_val="/\##{feature_name}"
    else
      feature_name_val=""
    end
    "/gamsat-preparation-courses/#{product_version_hashes[name]}#{feature_name_val}"
  end

  def dynamic_umat_product_version_uri(name, feature_name="")
    product_version_hashes = {
      'online-basic' => 'online-essentials',
      'online' => 'online-comprehensive',
      'attendence-basic' => 'attendance-essentials',
      'attendence' => 'attendance-comprehensive',
      'attendence-all' => 'attendance-complete-care',
      'custom' => 'custom'
    }
    if feature_name.present?
      feature_name_val="/\##{feature_name}"
    else
      feature_name_val=""
    end
    "/umat-preparation-courses/#{product_version_hashes[name]}#{feature_name_val}"
  end

  def dynamic_product_version_uri(product_version, product_line,
    subject="", feature_name="")

      product_line = product_line.upcase
      product_version_hashes = {
        'online-basic' => 'online-essentials',
        'online-comprehensive' => 'online-comprehensive',
        'online' => 'online-comprehensive',
        'attendance-essentials' => 'attendance-essentials',
        'attendance-basic' => 'attendance-essentials',
        'attendance' => 'attendance-comprehensive',
        'attendance-comprehensive' => 'attendance-comprehensive',
        'attendance-all' => 'attendance-comprehensive-private-tutoring',
        'custom' => 'custom',
        'free-trial' => '1-week-trial',
        'vce-free-trial' => 'free-trial',
        'hsc-free-trial' => 'free-trial',
        'success-assured' => 'success-assured'
      }
      gamsat_version_hashes = {
        'online-basic' => 'online-essentials',
        'online' => 'online-comprehensive',
        'attendance-basic' => 'attendance-essentials',
        'attendance' => 'attendance-comprehensive',
        'attendance-all' => 'attendance-complete-care',
        'custom' => 'custom',
        'free-trial' => 'free-trial',
        'interviewready-attendance-comprehensive' => 'interview-attendance-comprehensive',
        'interviewready-attendance-essentials' => 'interview-attendance-essentials',
        'interviewready-online-essentials' => 'interview-online-essentials',
        'starter' => 'gamsat-starter',
        'success-assured' => 'success-assured'
      }
      umat_version_hashes = {
        'online-basic' => 'online-essentials',
        'online' => 'online-comprehensive',
        'attendance-basic' => 'attendance-essentials',
        'attendance' => 'attendance-comprehensive',
        'attendance-all' => 'attendance-complete-care',
        'custom' => 'custom',
        'free-trial' => 'free-trial',
        'starter' => 'umat-starter'
      }

    if feature_name.present?
      feature_name_val="/\##{feature_name}"
    else
      feature_name_val=""
    end

    if product_line == 'VCE' && subject == 'english' && product_version == 'vce-free-trial'
      "/vce/vce-english-#{product_version_hashes[product_version]}#{feature_name_val}"
    elsif product_line == 'VCE' && subject == 'english'
      "/vce/english-advanced-#{product_version_hashes[product_version]}#{feature_name_val}"
    elsif product_line == 'HSC' && subject == 'english' && product_version == 'hsc-free-trial'
      "/hsc/hsc-english-#{product_version_hashes[product_version]}#{feature_name_val}"
    elsif product_line == 'HSC' && subject == 'english'
      "/hsc/english-advanced-#{product_version_hashes[product_version]}#{feature_name_val}"
    elsif product_line == 'VCE' && subject == 'math'
      if product_version == 'vce-free-trial'
        "/vce/vce-maths-#{product_version_hashes[product_version]}#{feature_name_val}"
      elsif product_version == 'custom'
        "/vce/mathematical-methods-cas-#{product_version_hashes[product_version]}#{feature_name_val}"
      else
      "/vce/math-extension-1-#{product_version_hashes[product_version]}#{feature_name_val}"
      end
    elsif product_line == 'HSC' && subject == 'math' && product_version == 'hsc-free-trial'
      "/hsc/hsc-maths-#{product_version_hashes[product_version]}#{feature_name_val}"
    elsif product_line == 'HSC' && subject == 'math'
      "/hsc/math-extension-1-#{product_version_hashes[product_version]}#{feature_name_val}"
    elsif product_line == 'UMAT'

      "/umat-preparation-courses/#{umat_version_hashes[product_version]}#{feature_name_val}"
    elsif product_line == 'GAMSAT'
      "/gamsat-preparation-courses/#{gamsat_version_hashes[product_version]}#{feature_name_val}"
    end
  end

  def dynamic_desc(names_array, course_name=false, course_desc=nil)
    sub_url = "pages/partial/vce_hsc_shared/"
    course = String.new
    if course_desc.eql?('free online exams')
      course = 'free_online_exams'
      sub_url << course
    else
      if names_array.include? 'trial'
        sub_url << 'trial'
        course = 'trial'
      elsif names_array.include? 'study_guide'
        sub_url << 'trial'
        course = 'trial'
      elsif names_array.include?('attendence') || names_array.include?('attendance')
        if names_array.include? 'comprehensive'
          course = 'attendance_comprehensive'
          sub_url << course
        else
          course = 'attendance_essentials'
          sub_url << course
        end
      elsif names_array.include? 'online'
        if names_array.include? 'interview'
          course = 'course_description'
          sub_url << course
        elsif names_array.include? 'comprehensive'
          course = 'online_comprehensive'
          sub_url << course
        else
          course = 'online_essentials'
          sub_url << course
        end
      else
        course = 'course_description'
        sub_url << course
      end
    end

    # return the true course identifier if required
    if course_name
      return course
    else
      return sub_url
    end
  end

  def ppr_course_desc(course_type)
    sub_url = "public_page_partial/pv/course_description/"
    course = String.new
    if course_type == 4
      course = 'online_essentials'
    elsif course_type == 5
      course = 'online_comprehensive'
    elsif course_type == 6
      course = 'attendance_essentials'
    elsif course_type == 7
      course = 'attendance_comprehensive'
    elsif course_type == 8
      course = 'attendance_complete'
    elsif course_type == 0
      course = 'trial'
    elsif course_type == 10
      course = 'free_study_guide'
    elsif course_type == 11
      course = 'starter'
    else
      course = 'course_description'
    end
    sub_url << course

  end

  def new_dynamic_desc(course_type, course_name=false, course_desc=nil)
    sub_url = "pages/partial/vce_hsc_shared/"
    course = String.new

    if course_desc.eql?('free online exams')
      course = 'free_online_exams'
      sub_url << course
    else
      course_type = ProductVersion.course_types[course_type]
      if course_type == 4
        course = 'online_essentials'
      elsif course_type == 5
        course = 'online_comprehensive'
      elsif course_type == 6
        course = 'attendance_essentials'
      elsif course_type == 7 || course_type == 8
        course = 'attendance_comprehensive'
      elsif course_type == 0
        course = 'trial'
      elsif course_type == 10
        course = 'free_study_guide'
      else
        course = 'course_description'
      end
    end
    sub_url << course

    # return the true course identifier if required
    if course_name
      return course
    else
      return sub_url
    end

  end

  def product_faq_uri name
    # TODO_1: sanitise and standardise FAQ url
    # TODO_2: add valid VCE url when in database
    sub_url = "/#{name}/faq/"
    if name.downcase == 'gamsat' || name == 'GamsatReady'
      "gamsat/faq/" + "enrolment-and-payment#refund-policy"
    elsif name.downcase == 'umat' || name == 'UmatReady'
      "umat/faq/"+ "enrolment-and-payment-queries#what-is-refund-policy"
    elsif name.downcase == 'vce' || name == 'VceReady'
      "vce/faq/" + "enrolment-and-payment-queries-8ce773eb-d42b-46e5-94fc-de2af251151f#what-is-the-refund"
    elsif name.downcase == 'hsc' || name == 'HscReady'
      "hsc/faq/" + "enrolment-and-payment-queries-8d98aefc-ed4d-4f26-a324-3addac1c2587#what-is-the-refund"
    end
  end

  def product_faq_expiry name
    if name.downcase == 'gamsat' || name == 'GamsatReady'
      "gamsat/faq/" + "preparing-for-the-gamsat#contact_eight_id"
    elsif name.downcase == 'umat' || name == 'UmatReady'
      "gamsat/faq/"+ "preparing-for-the-gamsat#contact_eight_id"
    elsif name.downcase == 'vce' || name == 'VceReady'
      "gamsat/faq/" + "preparing-for-the-gamsat#contact_eight_id"
    elsif name.downcase == 'hsc' || name == 'HscReady'
      "gamsat/faq/" + "preparing-for-the-gamsat#contact_eight_id"
    end
  end

  def course_faq_expiry name
    if name.downcase == 'gamsat' || name == 'GamsatReady'
      "/gamsat-preparation-courses/faq/enrolment-and-payment#contact_ten_id"
    elsif name.downcase == 'umat' || name == 'UmatReady'
      "umat-preparation-courses/faq/enrolment-and-payment-queries#contact_ten_id"
    end
  end

  def product_faq_installment type
    if type == 'gamsat'
      "gamsat-preparation-courses/faq/" + "enrolment-and-payment#Instalments"
    elsif type == 'umat'
      "umat-preparation-courses/faq/"+ "enrolment-and-payment-queries#am-i-able-to-pay"
    elsif type == 'vce'
      "vce/faq/" + "enrolment-and-payment-queries-8ce773eb-d42b-46e5-94fc-de2af251151f#am-i-able-to"
    elsif type == 'hsc'
      "hsc/faq/" + "enrolment-and-payment-queries-8d98aefc-ed4d-4f26-a324-3addac1c2587#Am I able to pay in instalments/ a deposit to reserve a place?"
    end
  end

  def product_terms_uri name
    if name.downcase == 'gamsat' || name == 'GamsatReady'
     "gamsat/terms"
    elsif name.downcase == 'umat' || name == 'UmatReady'
      "umat/terms"
    elsif name.downcase == 'vce' || name == 'VceReady'
      "vce/terms"
    elsif name.downcase == 'hsc' || name == 'HscReady'
      "hsc/terms"
    end

  end

  def dynamic_enhance_images(product_line)
    case product_line
    when "umat", "UMAT"
      "https://gradready.s3.ap-southeast-2.amazonaws.com/static/icons/enhance_umat.png"
    when "hsc", "HSC"
      "https://gradready.s3.ap-southeast-2.amazonaws.com/static/icons/enhance_hsc.png"
    when "vce", "VCE"
      "https://gradready.s3.ap-southeast-2.amazonaws.com/static/icons/enhance_vce.png"
    else
      "https://gradready.s3.ap-southeast-2.amazonaws.com/static/icons/enhance.png"
    end
  end

  def dynamic_new_star_images(product_line)
    case product_line
    when "umat", "UMAT"
      "https://gradready.s3.ap-southeast-2.amazonaws.com/static/icons/str_umat.png"
    when "hsc", "HSC"
      "https://gradready.s3.ap-southeast-2.amazonaws.com/static/icons/str_hsc.png"
    when "vce", "VCE"
      "https://gradready.s3.ap-southeast-2.amazonaws.com/static/icons/str_vce.png"
    else
      "http://gradready.s3.ap-southeast-2.amazonaws.com/static/icons/grn_star.png"
    end
  end

  def appropriate_icon(product_line)
    link_class=["enhance_icon"]

    case product_line
      when "UMAT"
        link_class.append(:umat_enhance)
      when "VCE"
        link_class.append(:vce_txt)
      when "HSC"
        link_class.append(:hsc_color)
      else
        link_class.append(:gamsat_enhance)
    end

    return link_class
  end

  # Return subject name from name of a tag
  # (e.g VE2.10 English should return English)
  def subject_name tag_name
    subject_name = String.new
    tag_name.split(" ").each do |sub_str|
      if !(sub_str =~ /\d/)
        subject_name << sub_str + ' '
      end
    end
    return subject_name
  end

  def show_course_price(course_type)
    course_type = ProductVersion.course_types[course_type]
    span= [""]
    if course_type == 0 || course_type == 1
      span.append(:disable)
    end
  end

  def show_trial_button(slug)
    span= [""]
    if slug == '1-week-trial' || slug == 'umat-free-trial'
      span.append(:disable)
    end
  end

  # Renders stars. To render 4.5 stars, pass 9 as first argument
  def render_stars(half_stars)
    rendered_stars = 0
    rendered = ''
    rendered += content_tag('i', '', class: 'fa fa-star fa-2x icon-green').to_s * (half_stars / 2)
    rendered_stars += half_stars / 2
    rendered += content_tag('i', '', class: 'fa fa-star-half-o fa-2x icon-green').to_s * (half_stars % 2)
    rendered_stars += half_stars % 2
    rendered += content_tag('i', '', class: 'fa fa-star-o fa-2x icon-green').to_s * (5 - rendered_stars)
    rendered.html_safe
  end
end
