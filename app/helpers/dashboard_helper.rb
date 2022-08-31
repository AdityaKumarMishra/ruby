module DashboardHelper
  def feature_hash(feature_name)
    ## TODO: This needs to be updated to be dynamic from the models/features folder
    features = {
      'Mcq' => {
        url: "exercises_path",
        icon: "fa fa-plus-square",
        title: "MCQs"
      },
      'McqStem' => {
        url: "exercises_path",
        icon: "fa fa-plus-square",
        title: "MCQs"
      },
      'Vod' => {
        url: "dashboard_vods_path",
        icon: "fa fa-video-camera",
        title: "Videos"
      },
      'Essay' => {
        url: "essays_path",
        icon: "fa fa-pencil",
        title: "Essays"
      },
      'Exam' => {
        url: "exams_path",
        icon: "fa fa-tag",
        title: "Exams"
        },
      'Textbook' => {
            url: 'dashboard_textbooks_path',
            icon: 'fa fa-book',
            title: 'Textbooks'
      },
      'Book Tutor' => {
        url: 'dashboard_book_tutor_path',
        icon: 'fa fa-calendar-plus-o',
        title: 'Book Tutor'
      }
    }
    features[feature_name]
  end

  def appointment_locations(appointments)
    appointments.map(&:location).reject(&:blank?).uniq.join(', ')
  end

  def tab_collection
    [
      ["Reasoning Textbook(Online TB) DL - No", "/dashboard/textbooks?type=additional_chapters"],
      ["Foundation Textbook(Online or Hardcopy TB) DL - No", "/dashboard/textbooks?type=textbook_chapters"],
      ["Textbook Slides(Online or Hardcopy TB) DL - No", "/dashboard/textbooks?type=textbook_slides"],
      ["PBL Additional Resources (PBLs) DL - Yes", "/dashboard/textbooks?type=attendance_course_resources"],
      ["PBL In-Class Slides (PBLs) DL - No",'/dashboard/textbooks?type=attendance_course_slides'],
      ["Revision Weekend (Revision Weekend) DL - No", "/dashboard/textbooks?type=revision_weekend"],
      ["Mock Exam (Online Exams) DL - No", "/dashboard/textbooks?type=mock_exam"],
      ["Supplementary Resources (All paying and non-paying students) DL - No", "/dashboard/textbooks?type=supplementary_resources"],
      ["Downloadable Resources (All paying and non-paying students) DL - Yes", "/dashboard/textbooks?type=downloadable_resources"]
    ]
  end

  def select_tab_values(type)
    case type 
      when 'attendance_course_resources'
        "/dashboard/textbooks?type=attendance_course_resources"
      when 'attendance_course_slides'
        '/dashboard/textbooks?type=attendance_course_slides'
      when'textbook_chapters'
        '/dashboard/textbooks?type=textbook_chapters'
      when 'additional_chapters'
        '/dashboard/textbooks?type=additional_chapters'
      when 'revision_weekend'
        '/dashboard/textbooks?type=revision_weekend'
      when 'mock_exam'
        '/dashboard/textbooks?type=mock_exam'
      when 'textbook_slides'
        '/dashboard/textbooks?type=textbook_slides'
      when 'supplementary_resources'
        '/dashboard/textbooks?type=supplementary_resources'
      when 'downloadable_resources'
        '/dashboard/textbooks?type=downloadable_resources'
      else 
        '/dashboard/textbooks(type: additional_chapters)'
    end

  end

  def appointment_view_selections
    if current_user.manager? || current_user.admin? || current_user.superadmin?
      [["PT Sessions by Tutor - Session Sum"], ["PT Sessions by Tutor - Student Breakdown" ], ["PT Sessions by Student - Unused Sessions"]]
    elsif current_user.tutor?
      [["Log Hours"], ["PT Sessions by Tutor - Student Breakdown"]]
    end
  end

  def appointment_view_selections_default
    if current_user.manager? || current_user.admin? || current_user.superadmin?
      "PT Sessions by Tutor - Session Sum"
    else
      "Log Hours"
    end
  end

  def display_args(selection)
    all_args = {
      "PT Sessions by Tutor - Session Sum" => { partial: 'dashboard/tutor_appointments',
                                                locals: { appointments: @appointments, tutors: @tutors, availablities: @availablities } },
      "PT Sessions by Tutor - Student Breakdown" => { partial: 'dashboard/student_tutor_appointment' },
      "PT Sessions by Student - Unused Sessions" => { partial: 'dashboard/unbooked_student_tutor_appointment' },
      "Log Hours" => { partial: 'tutor_availabilities/booked_appointments',
                       locals: { booked_appointments: current_user.tutor_profile.tutor_appointments.active.where(course_id: @courses.ids) } }
    }

    selection = appointment_view_selections_default if selection.blank?
    all_args[selection]
  end

  def default_date 
    date_to_display = @filterrific.with_end_filter.try(:to_date)
    date_to_display = (date_to_display + 2) if date_to_display == Date.today
    return date_to_display
  end

  def get_textbook(textbook)
    return textbook.textbook_reads.find_by(user_id: current_user.id)
  end

end
