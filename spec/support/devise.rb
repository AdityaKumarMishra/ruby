module Support
  module Devise
    def sign_in(user = nil)
      if user.nil?
        request.env['warden'].stubs(:authenticate!).raises(:warden, {scope: :user})
        ApplicationController.any_instance.stubs(:current_user).returns nil
      else
        request.env['warden'].stubs(authenticate!: user)
        ApplicationController.any_instance.stubs(:current_user).returns user
      end
    end
  end
end
