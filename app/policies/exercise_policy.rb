class ExercisePolicy < ApplicationPolicy
  class Scope < Scope
    def initialize(user, exercise_class)
      @user = user
      @exercise_class = exercise_class
    end

    def resolve
      if @user.student?
        course_tag_ids = @user.current_course_tags.map(&:id)
        @user.exercises.includes(:tags).where(course_id: @user.active_course.try(:id), tags: { id: course_tag_ids })
      end
    end
  end

  def initialize(user, exercise)
    @user = user
    @exercise = exercise
  end

  def show?
    @user.exercises.include?(@exercise)
  end

  def new?
    # @exercise is already belongs to user
    if @user.student?
      if @user.accessible_features.where("name ILIKE ?", "%MCQFeature").blank?
        false
      else
        true
      end
    end
  end

  def create?
    # if the exercise's tags belongs to user's mcqstem tags
    @user.student? && !(@exercise.tags - @user.tags_for_model(McqStem)).empty?
  end

  def update?
    create?
  end

  def destroy?
    @exercise.user == @user
  end

  def repeat?
    @exercise.completed_at.present?
  end
end
