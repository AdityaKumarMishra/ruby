# Authorization for Tag class
# Only non-student user can edit tags
class TagPolicy < ApplicationPolicy
  # Scope for index
  # Non-student can view all tags
  class Scope < Scope
    def initialize(user, tag_class)
      @user = user
      @tag_class = tag_class
    end

    def resolve
      if @user.nil?
        Tag.where(is_public: true).order(:name)
      elsif @user.student?
        user_tag_ids = @user.current_course_tags
        public_tag_ids = Tag.where(is_public: true).pluck(:id)
        Tag.where(id: (user_tag_ids + public_tag_ids)).order(:name)
      else
        Tag.order(:name)
      end
    end
  end

  def initialize(user, tag)
    @user = user
    @tag = tag
  end

  def show?
    can_read?
  end

  def list?
    can_read?
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
    @user.superadmin? || @user.admin?
  end

  def answerer_for_tag?
    true
  end

  def children_for_tag?
    true
  end

  private
  def can_read?
    if @user.nil?
      @tag.is_public
    elsif @user.student?
      @tag.is_public || @user.children_course_tags.include?(@tag)
    else
      true
    end
  end
end
