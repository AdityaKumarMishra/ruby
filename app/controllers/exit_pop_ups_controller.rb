class ExitPopUpsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_exit_popup, only: [:edit, :update, :destroy]
  layout 'layouts/dashboard'
  before_action :check_admin, only: [:index, :edit, :new, :destroy, :create]

  def index
    @exit_popups = ExitPopUp.all
  end

  def new
    @exit_pop_up = ExitPopUp.new
  end

  def edit
  end

  def create
    @exit_pop_up = ExitPopUp.new(exit_popup_params)
    respond_to do |format|
      if @exit_pop_up.save
        format.html { redirect_to exit_pop_ups_path, notice: 'ExitPopUp was successfully created.' }
      else
        format.html { render :new }
        format.json { render json: @exit_pop_up.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  def update
    respond_to do |format|
      if @exit_pop_up.update(exit_popup_params)
        format.html { redirect_to exit_pop_ups_path, notice: 'ExitPopUp was successfully updated.' }
      else
        format.html { render :edit }
        format.json { render json: @exit_pop_up.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  def destroy
    @exit_pop_up.destroy
    respond_to do |format|
      format.html { redirect_to exit_pop_ups_path, notice: 'ExitPopUp was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_exit_popup
    @exit_pop_up = ExitPopUp.find_by_id(params[:id])
  end

  def check_admin
    redirect_to root_path and return if current_user.student?
  end

  def exit_popup_params
    params.require(:exit_pop_up).permit(
      :display_name,
      :message,
      :visible_to_user,
      :btn_text,
      :btn_url,
      :category,
      :popup_frequency,
      :cookie_name
    )
  end

end
