class FeatureLogPolicy < ApplicationPolicy
  class Scope < Scope
    def initialize(user, feature_logs)
      @user = user
      @feature_logs = feature_logs
    end

    def resolve
      if @user.student?
        @feature_logs.includes(:purchase_item, feature_enrolment: [:feature, enrolment: [:user, :course]]).
            where("enrolments.user_id  = ? and features IS NOT NULL", @user).references(:enrolments, :features)
      else
        @feature_logs.select {|fe| fe.enrolment.present? && fe.feature.present?}
      end
    end
  end
  def initialize(user, feature_log)
    @user = user
    @feature_log = feature_log
  end

  def show?
    !@user.student? || @feature_log.enrolment.user==@user
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
    (!@user.student? || @feature_log.enrolment.user==@user)
  end

  def purchase_mcqs?
    add_to_cart?
  end
end
