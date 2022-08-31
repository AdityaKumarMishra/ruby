class ExerciseService < ApplicationService

  def initialize(params, current_user)
    @params = params
    @current_user = current_user
  end

  def exercise_new(current_course)
    master_feature = @current_user.accessible_features.find_by('name LIKE?', '%McqFeature%')
    @announcement = Announcement.find_by(master_feature_id: master_feature.try(:id), product_line_id: current_course.try(:product_version).try(:product_line_id))
    if @announcement.present?
      @user_announcement = @current_user.user_announcements.find_by(announcement_id: @announcement.id)
      @user_announcement = @current_user.user_announcements.create(announcement_id: @announcement.id, viewed: false) unless @user_announcement.present?
    end

    @exercise = @current_user.exercises.build
    @taggings = @exercise.taggings.build
    @current_user.mcq_statistics.destroy_all
    if @current_user.mcq_statistics.blank? && !@current_user.exercises.where.not(completed_at: nil).present?
      @current_user.create_tag_mcq_statistic
    end
    @available_tags = @current_user.current_feature_tags('McqFeature')
    @course = current_course
    return @announcement, @user_announcement, @exercise, @taggings, @available_tags, @course
  end
end
