class CourseRecommenderUsage < ApplicationRecord
  class << self
    def course_recommended
      courses = ["Online (Essentials)", "Online (Comprehensive)", "Attendance (Essentials)", "Attendance (Comprehensive)", "Attendance (Complete Care)", "Custom"]
      recommended = {}
      recommended[:gamsat] = []
      recommended[:umat] = []
      recommended[:hsc_eng] = []
      recommended[:hsc_math] = []
      recommended[:vce_eng] = []
      recommended[:vce_math] = []
      gamsat_course = CourseRecommenderUsage.where(product_line: "GAMSAT")
      umat_course = CourseRecommenderUsage.where(product_line: "UMAT")
      hsc_eng_course = CourseRecommenderUsage.where(subject: "English Advanced", product_line: "HSC")
      hsc_math_course = CourseRecommenderUsage.where(subject: "Mathematics Extension 1", product_line: "HSC")
      vce_eng_course = CourseRecommenderUsage.where(product_line: "VCE", subject: "English")
      vce_math_course = CourseRecommenderUsage.where(product_line: "VCE", subject: "Mathematical Method")
      courses.each do |col|
        flag = false
        gamsat_course.each do |cr|
          course = cr.course_name.split("GAMSAT: ")[1]
          if col == course
            flag = true
            recommended[:gamsat] << cr.complete
          end
        end
        if flag == false
          recommended[:gamsat] << 0
        end
        flag = false
        umat_course.each do |cr|
          course = cr.course_name.split("UMAT: ")[1]
          if col == course
            flag = true
            recommended[:umat] << cr.complete
          end
        end
        if flag == false
          recommended[:umat] << 0
        end
        hsc_eng_course.each do |cr|
          course = cr.course_name.split("HSC: ")[1]
          if col == course
            flag = true
            recommended[:hsc_eng] << cr.complete
          end
        end
        hsc_math_course.each do |cr|
          course = cr.course_name.split("HSC: ")[1]
          if col == course
            flag = true
            recommended[:hsc_math] << cr.complete
          end
        end
        vce_eng_course.each do |cr|
          course = cr.course_name.split("VCE: ")[1]
          if col == course
            flag = true
            recommended[:vce_eng] << cr.complete
          end
        end
        vce_math_course.each do |cr|
          course = cr.course_name.split("VCE: ")[1]
          if col == course
            flag = true
            recommended[:vce_math] << cr.complete
          end
        end
        if flag == false
          recommended[:hsc_eng] << 0
          recommended[:hsc_math] << 0
          recommended[:vce_eng] << 0
          recommended[:vce_math] << 0
        end
      end
      recommended
    end
  end
end
