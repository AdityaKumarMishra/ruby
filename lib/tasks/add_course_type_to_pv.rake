namespace :add_course_type_to_pv do
  task add_course_type: :environment do
    # For Free Trail
    product_versions = ProductVersion.where(name: ["UMAT - Free Trial", "GAMSAT - Free Trial"])
    product_versions.update_all(course_type: ProductVersion::course_types['free_trial'])

    # For Custom Course
    product_versions = ProductVersion.where(name: 'Custom')
    product_versions.update_all(course_type: ProductVersion::course_types['custom'])

    # For InterView Essential
    product_versions = ProductVersion.where(name: 'InterviewReady Essentials')
    product_versions.update_all(course_type: ProductVersion::course_types['interview_essential'])

    # For interview_comprehensive
    product_versions = ProductVersion.where(name: 'InterviewReady Comprehensive')
    product_versions.update_all(course_type: ProductVersion::course_types['interview_comprehensive'])

    # For InterView Essential
    product_versions = ProductVersion.where(name: "Online (Essentials)")
    product_versions.update_all(course_type: ProductVersion::course_types['online_essential'])

    # For online_comprehensive
    product_versions = ProductVersion.where(name: "Online (Comprehensive)")
    product_versions.update_all(course_type: ProductVersion::course_types['online_comprehensive'])

    # For attendance_essential
    product_versions = ProductVersion.where(name: ["Attendance (Essentials)", "UmatReady - Attendence (Essentials)"])
    product_versions.update_all(course_type: ProductVersion::course_types['attendance_essential'])

    # For attendance_comprehensive
    product_versions = ProductVersion.where(name: ["Attendence (Comprehensive)", "Attendance (Comprehensive)"])
    product_versions.update_all(course_type: ProductVersion::course_types['attendance_comprehensive'])

    # For attendance_complete care
    product_versions = ProductVersion.where(name: ["Attendence (Comprehensive + Private Tutoring)", "Attendance (Comprehensive + Private Tutoring)"])
    product_versions.update_all(course_type: ProductVersion::course_types['attendance_complete'])
  end
end
