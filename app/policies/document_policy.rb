class DocumentPolicy < ApplicationPolicy
  class Scope < Scope
    def initialize(user, document_class)
      @user = user
      @document_class = document_class
    end

    def resolve
      if @user.student?
        tag_ids = @user.current_feature_tags('DocumentsFeature')
        @document_class = @document_class.includes(:taggings).where(taggings: { tag_id: tag_ids })
        course_type = @user.active_course.try(:product_version).try(:course_type)
        course_type = ProductVersion.course_types[course_type]
        case course_type
        when 0
          @document_class.where(for_trial: true)
        when 6, 7, 8
          @document_class.where('for_paid = true OR for_timetable = true')
        else
          @document_class.where(for_paid: true)
        end
      else
        @document_class.all
      end
    end
  end

  def initialize(user, document)
    @user = user
    @document = document
  end

  def show?
    true
  end

  def create?
    !@user.student?
  end

  def edit?
    create?
  end

  def new?
    create?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end

  def access?
    @user
  end

  def download_file?
    true
  end

  def download?
    true
  end

  def index?
    if @user.student?
      if @user.accessible_features.where("name ILIKE ?", "%DocumentsFeature%").blank?
        false
      else
        true
      end
    else
      true
    end
  end
end
