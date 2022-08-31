class ManagersController < ApplicationController
  before_action :authenticate_user!

  layout "manager"

  def home
  end
end
