class VodPolicy < ApplicationPolicy
  class Scope < Scope
    def initialize(user, vod_class)
      @user = user
      @vod_class = vod_class
    end

    def resolve
      if @user.student?
        tag_ids = @user.current_feature_tags('VideoFeature')
        @vod_class.where(published: true).includes(:taggings).where(taggings: { tag_id: tag_ids })
      else
        @vod_class.all
      end
    end
  end

  def initialize(user, video)
    @user = user
    @video = video
  end

  def show?
    if @user.student?
      (@video.tags.ids - @user.current_feature_tags('VideoFeature').collect(&:id)).empty?
    else
      true
    end
  end

  def create?
    !@user.student?
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

  def index?
    if @user.student?
      if @user.accessible_features.where("name ILIKE ?", "%VideoFeature").blank?
        false
      else
        true
      end
    else
      true
    end
  end
end
