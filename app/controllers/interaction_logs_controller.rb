class InteractionLogsController < ApplicationController
  before_action :authenticate_user!

  def new
    @interaction_log = InteractionLog.new
  end

  def edit
    @interaction_log = InteractionLog.find_by(id: params[:id])
  end

  def create
    @interaction_log = InteractionLog.new(interaction_log_params)
    @interaction_log.created_at = interaction_log_params[:opened_at]
    @interaction_log.updated_at = interaction_log_params[:opened_at]
    respond_to do |format|
      if @interaction_log.save
        format.html { redirect_back fallback_location: root_path, notice: 'Interaction log was successfully created.' }
      end
    end
  end

  def update
    @interaction_log = InteractionLog.find_by(id: params[:id])
    respond_to do |format|
      if @interaction_log.update(interaction_log_params)
        format.html { redirect_back fallback_location: root_path, notice: 'Interaction log was successfully updated.' }
      end
    end
  end

  def destroy
    @interaction_log = InteractionLog.find_by(id: params[:id])
    respond_to do |format|
      if @interaction_log.destroy
        format.html { redirect_back fallback_location: root_path, notice: 'Interaction log was successfully deleted.' }
      end
    end
  end

  private
  def interaction_log_params
    params.require(:interaction_log).permit(:interaction_type, :title, :details, :asker_id, :answerer_id, :opened_at)
  end
end
