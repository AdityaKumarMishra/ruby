class GuideController < ApplicationController
  layout 'layouts/public_page'

  def index
    if current_user.present? && (current_user.admin? || current_user.superadmin?)
    else
      redirect_to root_path
    end
  end

end
