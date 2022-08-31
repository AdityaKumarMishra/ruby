namespace :add_type_to_lessons do
  task add_lesson_type: :environment do
    @mock_lessons = Lesson.where("item_covered LIKE ?", '%Mock%')
    @day_lessons = Lesson.where.not("item_covered LIKE ?", '%Mock%')
    @mock_lessons.update_all(lesson_type: 1)
    @day_lessons.update_all(lesson_type: 0)
  end
end
