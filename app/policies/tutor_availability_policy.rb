class TutorAvailabilityPolicy < ApplicationPolicy
  class Scope < Scope
    def initialize(user, tutor_availability_class)
      @user = user
      @tutor_availability_class = tutor_availability_class
    end

    def resolve
      tag_ids = @user.current_feature_tags('PrivateTutoringFeature')
      if @user.student? && tag_ids.present?
        @tutor_availability_class.includes(:tags).where("tags.id IN (?)", tag_ids).references(:tags)
      elsif @user.student?
        @tutor_availability_class.includes(:tags).none
      else
        @tutor_availability_class.all
      end
    end
  end

  def create?
    @user.tutor? && @user.tutor_profile.private_tutor
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
    create?
  end
end
