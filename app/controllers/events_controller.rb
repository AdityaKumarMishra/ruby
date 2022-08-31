class EventsController < ApplicationController
  before_action :authenticate_user!

  def index
    @events = Event.retriev_events current_user
  end

  def show
  end

  def destroy
  end
end
