class TextbookPolicy < ApplicationPolicy
  class Scope < Scope
    def initialize(user, textbook_class)
      @user = user
      @textbook_class = textbook_class
    end

    def resolve
      if @user.student?
        attd_feature = @user.accessible_features.find_by('name LIKE?', '%AttendanceTutorialsFeature%')
        docx_feature = @user.accessible_features.find_by('name LIKE?', '%DocumentsFeature%')
        text_feature = @user.accessible_features.find_by('name LIKE?', '%TextbookFeature%')

        if attd_feature.present?
          tag_ids = @user.current_feature_tags('AttendanceTutorialsFeature')
        elsif docx_feature.present?
          tag_ids = @user.current_feature_tags('DocumentsFeature')
        else
          tag_ids = @user.current_feature_tags('TextbookFeature')
        end

        if @user.active_course.textbooks.present? && tag_ids.present?
          @textbook_class.includes(:taggings).where('textbooks.id IN(?) OR taggings.tag_id IN(?)', @user.active_course.textbooks.pluck(:id), tag_ids).references('taggings').order(:title)
        else
          @textbook_class.includes(:taggings).where(taggings: {tag_id: tag_ids}).order(:title)
        end
      else
        @textbook_class.all
      end
    end
  end

  def initialize(user, textbook)
    @user = user
    @textbook = textbook
  end

  def show?
    if @user.student?
      if @textbook.course_id.present?
        true
      else
        if @user.active_course.present?
          if @user.active_course.present? && ProductVersion.course_types[@user.active_course.product_version.course_type] == 0 || ProductVersion.course_types[@user.active_course.product_version.course_type] == 10
            @user.current_feature_tags('DocumentsFeature').any?
          else
            @user.current_feature_tags('TextbookFeature').any? || @user.current_feature_tags('TextbookHardCopyFeature').any? || @user.current_feature_tags('DocumentsFeature').any?
          end
        end
      end
    else
      true
    end
  end

  def create?
    @user.superadmin? || @user.admin? || @user.manager?
  end

  def new?
    create?
  end

  def edit?
    create?
  end

  def update?
    create?
  end

  def destroy?
    @user.admin? || @user.superadmin?
  end
end
