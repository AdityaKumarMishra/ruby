class FeaturettePolicy < ApplicationPolicy
  class Scope < Scope
    def initialize(user, featurettes)
      @user = user
      @featurettes = featurettes

    end

    def resolve
      if @user.student?
        @featurettes.includes(:purchase_item, feature_enrolment: [:feature, enrolment: [:user, :course]]).
            where("enrolments.user_id  = ? and features IS NOT ?", @user, nil).references(:enrolments, :features)
      else
        @featurettes.select {|fe| fe.enrolment.present? && fe.feature.present?}
      end
    end
  end
  def initialize(user, featurette)
    @user = user
    @featurette = featurette
  end

  def show?
    !@user.student? || @featurette.user==@user
  end

  def create?
    !@user.student?
  end

  def update?
    !@user.student?
  end

  def destroy?
    !@user.student?
  end

  def add_to_cart?
    (!@user.student? || @featurette.feature_enrolment.enrolment.user==@user) && (!@featurette.purchase_item.present?)
  end
end
