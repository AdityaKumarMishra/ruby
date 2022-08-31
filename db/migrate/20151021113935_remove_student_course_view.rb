class RemoveStudentCourseView < ActiveRecord::Migration[6.1]
  def self.up
    execute <<-SQL
      DROP VIEW student_courses;
    SQL
  end

  def self.down
    execute <<-SQL
      CREATE VIEW student_courses AS
	      SELECT DISTINCT(s.course_version_id), scs.user_id
          FROM students_classes as scs
          LEFT JOIN student_classes as sc ON sc.id = scs.student_class_id
          LEFT JOIN subjects as s ON s.id = sc.subject_id
          where s.course_version_id IS NOT NULL AND scs.user_id IS NOT NULL
        UNION DISTINCT
        SELECT DISTINCT(s.course_version_id), us.user_id
          FROM subjects as s
          LEFT JOIN user_subjects as us ON us.subject_id = s.id
          where s.course_version_id IS NOT NULL  AND us.user_id IS NOT NULL
        UNION DISTINCT
	      SELECT DISTINCT(sc.course_version_id), scs.user_id
          FROM students_classes as scs
          LEFT JOIN student_classes as sc ON sc.id = scs.student_class_id
          where sc.course_version_id IS NOT NULL AND scs.user_id IS NOT NULL
    SQL
  end
end
