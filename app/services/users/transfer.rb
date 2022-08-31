module Users
  class Transfer
    attr_accessor :params, :user

    def initialize(params, user)
      @params = params
      @user = user
    end

    class << self
      def call(params, user)
        new(params, user).call
      end
    end

    def call
      if params[:type] == 'all_data'
        transferred = user.all_data_transfer_except_essay(params[:staffs])
        user.tutor_profile.update(private_tutor: false, issue_ticket: false) if user.tutor_profile.present?
        user.update_attribute(:data_transferred, true)
        staff = User.find(params[:staffs])
        staff.update_attribute(:data_transferred, false)
      else
        transferred = user.essay_data_transfer(params[:staffs])
        user.update_attribute(:essay_transferred, true)
        staff = User.find(params[:staffs])
        staff.update_attribute(:essay_transferred, false)
      end

      [user, staff]
    end
  end
end
