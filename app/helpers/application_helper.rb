module ApplicationHelper
  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      if msg_type == "error" || msg_type == "alert"
        if !(controller_name == "registrations" && action_name == "new")
          concat(content_tag(:div, message, class: ("notification-dialog alert alert new_alert wrong_det alert-dismissible alrt_div #{controller_name == "sessions" && action_name == "new" ? 'alrt_top' : ''}"), role: 'alert') do
            concat content_tag(:span, (image_tag 'https://gradready.s3.ap-southeast-2.amazonaws.com/static/wrong.png'), class: 'chk_mark')
            concat(content_tag(:button, class: 'close btn_top', data: { dismiss: 'alert' }) do
              concat content_tag(:span, '&times;'.html_safe, 'aria-hidden' => true)
              concat content_tag(:span, 'Close', class: 'sr-only')
            end)
            concat(content_tag(:span, class: "alert_msg cngrts_msg") do
              concat content_tag(:h4, 'Wrong Details', class: 'red_title')
              concat content_tag(:p, message.html_safe)
            end)
          end)
        end
      else
        if !(controller_name == "pages" && action_name == "main")
          concat(content_tag(:div, message, class: "notification-dialog alert new_alert cngrts_popup alert-dismissible alrt_div ", role: 'alert') do
            concat content_tag(:span, (image_tag 'https://gradready.s3.ap-southeast-2.amazonaws.com/static/cngrt_icon.png'), class: 'chk_mark')
            concat(content_tag(:button, class: 'close btn_top', data: { dismiss: 'alert' }) do
              concat content_tag(:span, '&times;'.html_safe, 'aria-hidden' => true)
              concat content_tag(:span, 'Close', class: 'sr-only')
            end)
            concat(content_tag(:span, class: "alert_msg cngrts_msg") do
              concat content_tag(:h4, 'Congratulations')
              concat content_tag(:p, message.html_safe)
            end)
          end)
        end
      end
    end
    flash.clear
    nil
  end

  def title(head_title=nil)
    title = ''
    if head_title.present?
      content_for :title, head_title
    else
      content_for?(:title) ? content_for(:title) : title
    end
  end

  def meta_keywords(keywords=nil)
    meta_keywords = ''
    if keywords.present?
      content_for :meta_keywords, keywords
    else
      content_for?(:meta_keywords) ? content_for(:meta_keywords) : meta_keywords
    end
  end

  def meta_description(desc=nil)
    meta_description = ''
    if desc.present?
      content_for :meta_description, desc
    else
      content_for?(:meta_description) ? content_for(:meta_description) : meta_description
    end
  end

  def post_title(post)
    case post.slug
      when "10-study-habits-that-work"
        "10 GAMSAT Study Tips and Tricks"
      when "gamsat-exam-what-to-do-the-night-before"
        "GAMSAT Exam: Last Minute Tips for the Night Before"
      when "life-hacks-organising-a-study-group"
        "Organising a GAMSAT Study Group"
      when "not-another-year-of-procrastination"
        "Avoiding Procrastination: Study Tips and Tricks"
      when "now-the-gamsat-s-done-what-can-i-do"
        "What can I do after the GAMSAT Exam?"
      when "studying-with-friends-and-pomodoros"
        "Preparing for the GAMSAT with Friends and Pomodoros"
      when "two-weeks-left-what-can-i-do"
        "Preparing for the GAMSAT with 2 Weeks Left"
      when "management-strategies-for-balancing-gamsat-study-with-university-work-other-life-commitments"
        "Balancing your GAMSAT Study with other Commitments"
      when "surviving-the-one-exam-to-rule-them-all-my-top-five-study-tips"
        "Top Five GAMSAT Study Tips"
      else
        (@post.name.include? "®") ? @post.name.gsub!('®','') : @post.name
    end
  end

  def post_description(post, pl)
    case post
      when "work-flow-systems"
        "Feeling the pressure of your final year at school and preparing for the UMAT Exam? Our experienced tutors share their advice on developing work flow systems to help you better manage your demands and remain productive."
      when "two-weeks-left-what-can-i-do"
        "Feeling stressed with two weeks till the #{pl} Exam? Take a deep breath and read some advice provided by our experienced tutors and medical students who share their tips on what you can do to maximise the time you have left."
      when "the-importance-of-volunteering-for-careers-in-medicine"
        "Volunteering itself is highly rewarding as you contribute to society and help those in need, but it is also a great opportunity to develop new skills and knowledge that will ultimately make you a better practitioner."
      when "now-the-gamsat-s-done-what-can-i-do"
        "Feeling a little lost after sitting the #{pl} Exam? Our experienced tutors provide advice on what you can and should do to help prepare for your Medical Application."
      when "is-my-gamsat-score-good-enough"
        "Your #{pl} results are out but what exactly do they mean for your Medical School Application? Our experienced tutors breakdown the different application criteria for medical schools around Australia and provide a list of cutoff scores"
      when "gamsat-section-ii-how-to-prepare"
        "Struggling with your preparation for Section 2 of the #{pl} Exam? Read our blog by an experienced tutor and successful medical student on how you can start preparing today!"
      when "gamsat-section-3-chemistry-how-to-prepare"
        "#{pl} Section 3 Chemistry is very much about the application of certain theories and ideas to specific problems. This is means that your #{pl} preparation can center around learning some basic principles and really refining their application in the context of the #{pl} exam."
      when "gamsat-section-1-how-to-prepare"
        "Our expert Section 1 Tutors share their advice on how you should prepare for Section 1 of the #{pl} exam. Get study tips and tricks for Section 1 and check out our #{pl} Reading list to help you ace Section 1"
      when "gamsat-exam-what-to-do-the-night-before"
        "Sitting the #{pl} Exam tomorrow? Make sure you're all prepared for the big day, with reminders on what you need to bring and advice on what you should be doing the night before - Hint: Cramming study is most definitely not on the list"
      when "free-gamsat-events"
        "Are you planning on sitting the #{pl} exam and not sure how to prepare? GradReady holds several free seminars dedicated to the complex world of medical school admissions throughout the year. These seminars are a must-see for anyone applying for medicine or contemplating sitting the #{pl} exam."
      when "gamsat-section-2-essay-tips-hit-them-in-the-feels-with-stories-and-metaphors"
        "When writing, especially in a scenario such as the #{pl} when you only have limited time and a less-than-captive audience it is important to make as big an impact as quickly as possible. This is so you distinguish yourself from the hordes of competitors and improve your chances."
      when "10-study-habits-that-work"
        "Although we like to think we have it all worked out, the majority of us struggle to find a study routine that works for us. Of course we all study differently, but there are things that work for just about everyone. The following 10 #{pl} Study Habits should help make your preparation more effective and efficient"
      when "life-hacks-organising-a-study-group"
        "For some, study groups are the norm, whereas for others they evoke painful memories. Whatever your experiences, study groups can promote motivation and social well-being. Here are some tips to help form your own #{pl} study group and make sure you get the most out of your #{pl} Prep with others. "
      when "management-strategies-for-balancing-gamsat-study-with-university-work-other-life-commitments"
        "Whilst studying for the #{pl} Exam might seem like an all consuming beast that holds the capacity to overpower your whole life, it does not need to be that way. Here are a few shards of knowledge on ways you might be able to find some balance amidst the fog and calamity of focused study."
      when "not-another-year-of-procrastination"
        "We all know the feeling. This year will be the year I will be effective. The year I will not procrastinate. But then SWOTVAC arrives and the same thing happens all over again. To help avoid the pitfalls and traps of procrastination, we listed some techniques and habits you can use everyday to make sure you work effectively"
      when "preparing-for-the-gamsat-with-a-non-science-background"
        "Thinking of tackling the #{pl} Exam without any science under your belt? Don't worry, you're not alone - This article will list some things that you might like to think about and tips to help you with your #{pl} Preparation"
      when "protecting-doctors-what-is-the-law"
        "Increasingly, health professionals are facing escalating violence and threats to personal safety. Just in the last month or so, paramedics have faced violent assaults, as an example. The question is, what can be done, and what is being done?"
      when "studying-with-friends-and-pomodoros"
        "Breaking your study up into short periods and using pomodoros can be a great way to remain productive throughout your #{pl} Preparation. Combine this with friends and you could have a great and fun way to mix up your study routine."
      when "surviving-the-one-exam-to-rule-them-all-my-top-five-study-tips"
        "Feeling the pressure of studying for the #{pl} Exam? Don't let the pressure overwhelm you - Here are five top tips on preparing for the #{pl} Exam, designed to help take the stress out of studying."
      when "what-are-my-postgraduate-options"
        "Not sure if the medicine is for you? It is important for students to properly assess and research their potential options before settling on any particular study or career path. Thankfully, there are plenty of great tools out there to help you make an informed decision."
      when "balancing-roles-medical-student-friend-family-member"
        "It is no secret that Medical School is tough. Even the best of us can find ourselves consumed by study and the stress of achieveing. However, it is important that you separate the different aspects of your life and maintain a balance to ensure you remain sane and look after yourself when the pressure builds. "
      when "writing-the-creative-gamsat-essay"
        "Essays are the bane of so many GAMSAT Students, and it can often feel hard to differentiate yourself from the rest of the pack. One potential approach is to challenge expectations and write a creative-style essay. It is not easy but when done well, it can set you apart and grab the attention of your readers."
      when "how-hard-is-the-gamsat"
        "Those who have sat the 6 hour test would probably all agree that, yes, the GAMSAT is difficult. However, how hard one person finds the exam is different to others, and it depends not only on their innate aptitudes, but also how effectively they have prepared."
      when "5-reasons-to-study-abroad"
        "Thinking about studying overseas? Although it can seem intimidating, taking a step outside of your comfort zone and spending some time abroad could be one of the most rewarding things you do."
      when "choosing-a-medical-school-does-prestige-matter"
        "There are numerous factors that you might take into account when trying to decide which medical school is best for you: location, career opportunities, research options, etc. But should prestige be one of those factors?"
      when "making-the-most-of-swotvac"
        "Often used as a time for students to cram, it can be difficult to maximise your SWOTVAC period. Whether it be procrastination or burning out, it is important to avoid the extremes to make the most of SWOTVAC."
      when "what-gpa-do-i-need"
        "With all the hysteria around the GAMSAT Exam it is easy to overlook an equally important part of your application, your GPA. But what exactly do you need in terms of a GPA and how does your GPA contribute to your overall score?"
      else
        ""
    end
  end

  def blog_description(cate, pl)
    case cate
      when "admissions"
        "Interested in the medical school admissions process? Our experienced tutors share their Med School journeys, in addition writing about a whole range ot topics, from the #{pl} exam, to studying medicine and useful study tips and tricks."
      when "announcements"
        "Get the latest news on the #{pl} Exam and the Medical Admissions Process. Our experienced tutors write about topics ranging from the #{pl} exam to life studying medicine, and share their top study tips and tricks."
      when "exam-tips"
        "Get all the tips and tricks you need for the #{pl} Exam from our experienced tutors. These Med Students write about a whole range of topics, from the best way to prepare for the #{pl} exam to their journeys studying medicine. "
      when "free-courses"
        "Make sure you sign up for GradReady's Free #{pl} Events! With courses all around Australia, find the next one near you. Our blog also contains articles from our experienced tutors on everything from sitting the #{pl} exam to life as a Med Student. "
      when "interviews"
        "Learn all the tips and tricks to acing your medical interview from our experienced tutors. These successful med students have been through the process themselves and share their advice on topics from sitting the #{pl} to acing your Medical Interviews."
      when "gamsat-exam-tactics"
        "Looking for the best tips and tricks to perfect your #{pl} exam strategy? Visit our blog where our experienced tutors share their advice on everything from sitting the #{pl} exam to life as a Med Student. "
      when "life-hacks"
        "Struggling to balance your #{pl} study with other commitments? Our experienced tutors share their life hacks. These successful med students have been through the process themselves and share their advice on how to balance your time to study effectively."
      when "medical-school-entry"
        "Interested in the medical school admissions process? Our experienced tutors share their advice on medical school entry. These successful medical students have been through the entire process and pass on what they've learnt, from sitting the #{pl} exam to making sense of the Medical Admissions Process. "
      when "medicine"
        "Interested in studying medicine? Our expert tutors share their experiences as medical students and write about a wide range of topics from sitting the #{pl} exam to going through the medical admissions process."
      when "practice-mcqs"
        "Get some useful last minute tips and tricks on how to sit the #{pl} exam and tackle MCQs from our experienced tutors. "
      when "study-tips"
        "Our experienced tutors share their advice and study tips on how to best prepare for the #{pl} Exam in addition to writing about a whole range of topics, from acing your interview to life as a medical student. "
      when "when-i-grow-up"
        "Not sure of your career choices after sitting the #{pl} Exam and getting into medicine? Our experienced tutors provide a breakdown of some of your options."
      when "study-tips-tricks"
        "Our experienced tutors share their advice and study tips on how to best prepare for the #{pl} Exam in addition to writing about a whole range of topics, from acing your interview to life as a medical student. "
      else
        "Our experienced tutors write about topics ranging from the #{pl} exam, to medicine, and study tips and tricks."
    end
  end

  def true_check(var)
    if var == true
      '<i class="fa fa-check"></i>'.html_safe
    else
      '<i class="fa fa-times"></i>'.html_safe
    end
  end

  def purchase_form products
    render :partial => 'partial/purchase_form', :locals => {:products => products} if products && products.any?
  end

  def is_active?(object)
    object.to_i > DateTime.now.to_i ? true : false
  end

  def format_date_short date
    I18n.l(date, :format => :short) if date
  end

  def format_date_long date
    I18n.l(date, :format => :long) if date
  end

  def format_time(time)
    I18n.l time, :format => :time
  end

  def available_high_schools
    HighSchool.pluck(:name)
  end

  ##
  # Returns product line this url belongs to in downcase
  # An empty string otherwise
  def map_url_to_product_line current_uri
    valid_products = ['gamsat', 'umat', 'vce', 'hsc']
    if current_uri.include? "gamsat-preparation-courses"
      current_uri= current_uri.gsub! "gamsat-preparation-courses", "gamsat"
    elsif current_uri.include? "umat-preparation-courses"
      current_uri= current_uri.gsub! "umat-preparation-courses", "umat"
    end
    paths = current_uri.split('/')
    if paths[1] == "posts"
      post = Post.find_by(slug: paths[2])
      product_line = post.present? ? post.blog_type : ''
    else
      product_line = paths.count != 0 && valid_products.include?(paths[1]) ? paths[1] : ''
    end
    if product_line == ''
      product_line = paths.count != 0 && valid_products.include?(paths[2]) ? paths[2] : ''
    end
    return product_line
  end

  def render_nav_bar current_uri
    current_nav = map_url_to_product_line(current_uri)
    if current_nav == ''
      current_nav = 'home'
    end
    render partial: "partial/#{current_nav}_main_menu"
  end

  # Exit popup modal for Homepage / GAMSAT / UMAT
  def check_product_for_exit_popup product_line
    if controller_name == "pages" && action_name == "main"
      @exit_popup = get_exit_popup('Homepage')
    elsif product_line == "gamsat"
      @exit_popup = get_exit_popup('Gamsat')
    elsif product_line == "umat"
      @exit_popup = get_exit_popup('Umat')
    end
  end

  def get_exit_popup(cat_name)
    exit_popup = get_exit_popup_object(cat_name)
    if !exit_popup.nil?
     return exit_popup
    end
  end

  def get_exit_popup_object(cat_name)
    exit_popup = ExitPopUp.where(category: cat_name, visible_to_user: true).last
    if !exit_popup.nil?
      return exit_popup
    else
      return nil
    end
  end

  def render_public_nav_bar current_uri, product_line_type
    if current_uri == "/umat-preparation-courses"
      render partial: "public_page_partial/public_mob_umat_header", locals: { product_line_type: product_line_type }
      # render partial: "public_page_partial/public_mob_home_header", locals: { product_line_type: product_line_type }
    else
      current_nav = map_url_to_product_line(current_uri)
      if current_nav == '' || current_nav == 'vce' || current_nav == 'hsc'
        current_nav = 'home'
      end
      if current_product_line == "umat"
        current_nav = 'umat'
      end
      render partial: "public_page_partial/public_mob_#{current_nav}_header", locals: { product_line_type: product_line_type }
    end
  end

  def render_public_mob_bar current_uri, product_line_type
    if current_uri == "/umat-preparation-courses"
      render partial: "public_page_partial/topnav_umat", locals: { product_line_type: 'umat' }
      # render partial: "public_page_partial/topnav_home", locals: { product_line_type: 'umat' }
    else
      current_nav = map_url_to_product_line(current_uri)
      if current_nav == '' || current_nav == 'vce' || current_nav == 'hsc'
        current_nav = 'home'
      end
      if current_product_line == "umat"
        current_nav = 'umat'
      end
      render partial: "public_page_partial/topnav_#{current_nav}", locals: { product_line_type: product_line_type }
    end
  end

  def map_prodline product_line
    out = {
        :GamsatReady => "gamsat",
        :UmatReady => "umat",
        :HscReady => "hsc",
        :VceReady => "vce"
    }
    out[product_line.to_sym]
  end

  def map_path_to_prodline prodline
    # TODO: Convert to Regex
    out = "gamsat-preparation-courses"
    ['gamsat-preparation-courses','umat-preparation-courses','umat','hsc','vce', 'ucat'].any? {|pl|
      if prodline.include?(pl)
        out = pl
      end }
    if out == "ucat" && prodline != "/gamsat-podcast/educated-guessing"
      out = "umat"
    end
    out
  end

  def map_path_to_prodline_footer prodline
    # TODO: Convert to Regex
    out = "gamsat"
    ['gamsat','umat','hsc','vce'].any? {|pl|
      if prodline.include?(pl)
        out = pl
      end }
    out
  end

  def sentry_tag
    return "" if ENV['SENTRY_DSN'].blank?

    html_out = javascript_include_tag 'https://cdn.ravenjs.com/3.0.4/raven.min.js', :defer => true

    # Don't expose private secrets
    # Sentry for Javascript should not require a secret
    dsn_uri = URI(ENV['SENTRY_DSN'])
    dsn_uri.password = nil

    # Extract URI without a secret
    public_dsn = dsn_uri.to_s

    html_out += javascript_tag "Raven.config('#{escape_javascript public_dsn}').install();"

    if current_user.nil?
      html_out += javascript_tag """
      Raven.setUserContext({
        anonymous_id: '#{cookies[:anonymous_user_id]}'
      });
      """
    else
      html_out += javascript_tag """
      Raven.setUserContext({
        email: '#{escape_javascript current_user.email}',
        id: #{current_user.id}
      });
      """
    end

    html_out
  end

  def is_same_route?(url)
    url = change_for_inner_pages(url)
    result = if request.env['PATH_INFO'].include?("/mock_exam_essays") && url == "/live_exams"
      true
    else
      request.env['PATH_INFO'].include?(url)
    end
    return result
  end

  def change_for_inner_pages(url)
    case url
    when '/exercises/new'
      '/exercises'
    when '/dashboard/textbooks'
      '/textbooks'
    else
      url
    end
  end

  def feature_icon(url)
    case url
      when "diagnostic_test_attempts_path"
        "diag_assessment_icon"
      when "new_exercise_path"
        "mcq_icon"
      when "vods_path"
        "video_icon"
      when "essay_responses_path"
        "my_essay_icon"
      when "online_exam_attempts_path"
        "exam_icon"
      when "dashboard_unresolved_issues_path"
        "getclarity_icon"
      when "dashboard_book_tutor_path"
        "book_tutor_icon"
      when "live_exams_path"
        "mock_exam_icon"
      else
        "diag_assessment_icon"
    end

  end

  def check_for_same_route?(url)
    return request.env['REQUEST_URI'].include? "feature_type=#{url}"
  end

  def get_title_by_course(index)
    course_titles = ["Online Essentials",
                  "Online Comprehensive",
                  "Classes Essentials",
                  "Classes Comprehensive",
                  "Private Tutoring & Classes"]

    "#{map_path_with_course} #{course_titles[index]}"
  end

  #Map url and course name
  def map_path_with_course
    case request.path
    when /gamsat/
      "GAMSAT"
    when /umat/
      "UMAT"
    when /hsc/
      "HSC"
    when /vce/
      "VCE"
    else
      ""
    end
  end

  def current_product_line
    case request.path
      when /gamsat/
        "gamsat"
      when /umat/
        "umat"
      when /hsc/
        "hsc"
      when /vce/
        "vce"
      when /ucat/
        "umat"
      else
        "gamsat"
    end
  end

  def current_nav_id
    user_signed_in? ? '#OtherNavbar' : '#GradNavbar'
  end

  def course_recommender_tag(show_course_recomender)
    if show_course_recomender == true
      render 'partial/course_recommender'
    end
  end

  def comparison_modal_tag
    active_urls = ['/gamsat', '/umat', '/hsc', '/vce']

    if active_urls.include? request.path
      render 'partial/comparison_modal'
    end
  end

  def hotjar_tag
    render 'partial/hotjar_installation' if Rails.env.production?
  end

  def free_trial_days(trial_enrolment)
    ((trial_enrolment.trial_expiry - Time.zone.now)/1.days).ceil
  end

  def upgrade_free_trial_title(trial_enrolment)
    expiry = free_trial_days(trial_enrolment)
    end_txt = case
    when(expiry == 1)
      "ends today"
    when(expiry > 1)
      "ends in #{expiry} days"
    when(expiry < 1)
      "has been expired"
    end
    text = "Hi #{trial_enrolment.user.first_name.try(:titleize)}, Your trial #{end_txt}"
  end

  def get_left_dashboard_announcement
    announcement = nil
    if current_user.present? && current_user.active_course.present?
      type = current_user.active_course.product_version.type
      if type == 'HscReady' || type == 'VceReady'
        f_name = current_user.active_course.name.include?('Math') ? "#{type}Math" : "#{type}English"
        name = f_name + '-dashboard'
      else
        name = type + '-dashboard'
      end
      announcement = Announcement.find_by(name: name, category: 'Dashboardpage')
    end
    unless announcement.nil?
      return announcement
    end
  end

  def dashboard_user_announcement_changed
    announcement = get_left_dashboard_announcement
    user_announcement = current_user.user_announcements.find_by(announcement_id: announcement.id) if announcement.present?
    if user_announcement.present? && !user_announcement.viewed && user_announcement.announcement.show_highlight || ( user_announcement.present? && !user_announcement.viewed && current_user.sign_in_count == 1)
      true
    else
      false
    end
  end

  def get_student_announcement_changed(product_line, master_feature)
    announcement = Announcement.find_by(product_line_id: product_line, master_feature_id: master_feature)
    return false if announcement.nil?
    user_announcement = current_user.user_announcements.find_by(announcement_id: announcement.id) if announcement.present?
    if user_announcement.present? && !user_announcement.viewed && user_announcement.announcement.show_highlight || ( user_announcement.present? && !user_announcement.viewed && current_user.sign_in_count == 1)
      true
    else
      false
    end
  end

  def product_line_class(product_line)
    button_class=["btn-gradready"]

    case product_line
      when "umat"
        button_class.append(:blue)
      when "vce"
        button_class.append(:purple)
      when "hsc"
        button_class.append(:red)
      else
        button_class.append(:grn_call_btn)
    end

    return button_class
  end

  def user_ongoing_order_link
    return current_user.validate_order if current_user.validate_order_presence

    order_path(-1, placeholder: true)
  end

  def recaptcha_rendered?
    controller_included = ['users/sessions', 'pages'].include? params[:controller]
    action_included = ['new', 'main'].include? params[:action]
    return controller_included && action_included
  end

end
